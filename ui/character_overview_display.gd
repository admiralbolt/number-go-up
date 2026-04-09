class_name CharacterOverviewDisplay extends Control

@onready var vbox: VBoxContainer = $HBoxContainer/VBoxContainer
@onready var level_label: Label = $HBoxContainer/VBoxContainer/LevelLabel
@onready var class_label: Label = $HBoxContainer/VBoxContainer/ClassLabel
@onready var xp_label: Label = $HBoxContainer/VBoxContainer/XPLabel
@onready var xp_bar: ProgressBar = $HBoxContainer/VBoxContainer/XPLabel/XPBar

func _ready() -> void:
  self.focus_entered.connect(self._on_focus_entered)
  self.focus_exited.connect(self._on_focus_exited)

  # Set neighbors.
  var children: Array[Node] = vbox.get_children()
  for i in range(children.size()):
    var child = children[i]
    child.focus_entered.connect(self._on_item_focused.bind(i, child.name))
    child.focus_exited.connect(self._on_item_exited.bind(i, child.name))
    child.focus_neighbor_top = children[(i - 1) % children.size()].get_path()
    child.focus_neighbor_left = child.get_path()
    child.focus_neighbor_right = child.get_path()
    child.focus_neighbor_bottom = children[(i + 1) % children.size()].get_path()

  _update()
  # Don't need to do any kind of complicated signal handling, just update
  # whenever the pause menu is opened.
  SignalBus.pause_menu_opened.connect(_update)

func _update() -> void:
  self.level_label.text = "Lvl. %d" % PlayerManager.player.level
  self.class_label.text = PlayerManager.player.character_class.name
  self.xp_bar.min_value = PlayerManager.player.starting_xp_this_level
  self.xp_bar.max_value = PlayerManager.player.total_xp_to_next_level
  self.xp_bar.value = PlayerManager.player.xp
  self.xp_label.text = "%d / %d" % [PlayerManager.player.xp, PlayerManager.player.total_xp_to_next_level]

func _on_focus_entered() -> void:
  self.vbox.get_child(PauseMenuState.overview_focus_index).grab_focus()

func _on_focus_exited() -> void:
  return

func _on_item_focused(index: int, _child_name: String) -> void:
  PauseMenuState.overview_focus_index = index
  var child: Node = vbox.get_child(index)
  child.add_theme_color_override("font_color", Color8(255, 255, 0))

func _on_item_exited(index: int, _child_name: String) -> void:
  var child: Node = vbox.get_child(index)
  child.remove_theme_color_override("font_color")
