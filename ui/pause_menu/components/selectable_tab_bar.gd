class_name SelectableTabBar extends Control

signal tab_selected(index: int, name: String)

@export var left_action: String = "tab_left"
@export var right_action: String = "tab_right"

@onready var tab_container: HBoxContainer = $HBoxContainer

var tabs: Array[SelectableIcon]

var selected_index: int = 0
var selected_tab_name: String = ""

func _ready() -> void:
  self.process_mode = Node.PROCESS_MODE_ALWAYS
  self.reload_children()
  
func clear() -> void:
  for tab in self.tabs:
    self.tab_container.remove_child(tab)
    tab.queue_free()

  self.tabs.clear()

func reload_children() -> void:
  for child in self.tab_container.get_children():
    self.tabs.append(child)

func set_selected_index(index: int) -> void:
  self.tabs[self.selected_index].deselect()
  self.selected_index = index
  self.selected_tab_name = self.tabs[self.selected_index].text
  self.tabs[self.selected_index].select()
  self.tab_selected.emit(self.selected_index, self.selected_tab_name)

func _unhandled_input(event: InputEvent) -> void:
  if not PauseMenuState.pause_menu_open:
    return

  if self.tabs.size() == 0:
    return

  if event.is_action_pressed(self.left_action):
    self.set_selected_index((self.selected_index - 1) % self.tabs.size())
    get_viewport().set_input_as_handled()
    return

  if event.is_action_pressed(self.right_action):
    self.set_selected_index((self.selected_index + 1) % self.tabs.size())
    get_viewport().set_input_as_handled()
    return
