class_name SelectableTabBar extends Control

signal tab_selected(index: int, name: String)
signal tab_activated(index: int, name: String)
signal tab_bar_exit

@onready var tab_container: HBoxContainer = $HBoxContainer
@onready var outline: Panel = $Outline
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var tabs: Array[SelectableIcon]
var selectable_indices: Array[int]

var selected_index: int = 0
var selected_tab_name: String = ""

var is_focused: bool = false
var is_frozen: bool = false

func _ready() -> void:
  self.process_mode = Node.PROCESS_MODE_ALWAYS

  for child in self.tab_container.get_children():
    tabs.append(child)

  # Set our focus neighbors appropriately. One tricky thing here, not all tabs
  # will necessarily be selectable. We need to do some extra logic to make
  # sure only selectable tabs.
  for i in range(self.tabs.size()):
    var tab: SelectableIcon = self.tabs[i]
    if tab.is_selectable:
      self.selectable_indices.append(i)

  # Now we actually iterate back through and set our focus neighbors.
  for i in range(self.tabs.size()):
    var tab: SelectableIcon = self.tabs[i]
    tab.focus_neighbor_top = tab.get_path()
    tab.focus_neighbor_bottom = tab.get_path()
    # If the tab isn't selectable, the focus neighbors shouldn't really matter.
    # Setting it to self just in case.
    if not tab.is_selectable:
      tab.focus_neighbor_left = tab.get_path()
      tab.focus_neighbor_right = tab.get_path()
      continue

    # In theory we could do a mapping from the child index -> selectable_indices
    # index, but considering the size, we just search by value every time.
    var index_index: int = self.selectable_indices.find(i)
    tab.focus_neighbor_left = self.tabs[self.selectable_indices[(index_index - 1) % self.selectable_indices.size()]].get_path()
    tab.focus_neighbor_right = self.tabs[self.selectable_indices[(index_index + 1) % self.selectable_indices.size()]].get_path()

    # Finally, whenever one of our tabs get selected, also emit it through to
    # the parents.
    tab.selected.connect(self._on_tab_selected.bind(i))

func _on_tab_selected(tab_name: String, index: int) -> void:
  self.selected_index = index
  self.selected_tab_name = tab_name
  self.tab_selected.emit(index, tab_name)

func set_selected_index(index: int, with_focus: bool = true) -> void:
  self.tabs[self.selected_index].deselect()

  self.selected_index = index
  self.selected_tab_name = self.tabs[self.selected_index].name
  if with_focus:
    self.tabs[self.selected_index].grab_focus()

func set_focused(p_is_focused: bool) -> void:
  self.is_focused = p_is_focused
  if self.is_focused:
    self.animation_player.play("flicker")
    self.tabs[self.selected_index].grab_focus()
    return

  self.animation_player.stop()

func freeze() -> void:
  self.is_frozen = true
  self.tabs[self.selected_index].is_frozen = true

func unfreeze() -> void:
  self.is_frozen = false
  self.tabs[self.selected_index].is_frozen = false

func _unhandled_input(event: InputEvent) -> void:
  if not self.is_focused:
    return

  if event.is_action_pressed("tab_left"):
    self.set_selected_index(self.selectable_indices[(self.selected_index - 1) % self.selectable_indices.size()])
    get_viewport().set_input_as_handled()
    return

  if event.is_action_pressed("tab_right"):
    self.set_selected_index(self.selectable_indices[(self.selected_index + 1) % self.selectable_indices.size()])
    get_viewport().set_input_as_handled()
    return

  if event.is_action_pressed("ui_accept"):
    self.tab_activated.emit(self.selected_index, self.selected_tab_name)
    get_viewport().set_input_as_handled()
    return

  if event.is_action_pressed("ui_cancel"):
    self.unfreeze()
    self.tab_bar_exit.emit()
    # We don't set input as handled. Let it bubble up to the content panel.
    return
