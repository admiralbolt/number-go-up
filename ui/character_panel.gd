class_name CharacterPanel extends Control

# Preload all our sub panel scene.
const CONTENT_PANEL_MAPPING: Dictionary[String, PackedScene] = {
  "AttributesButton": preload("res://ui/CharacterStatsDisplay.tscn"),
  "StatisticsButton": preload("res://ui/CharacterDerivedStatisticsDisplay.tscn"),
  "SkillsButton": preload("res://ui/CharacterSkillsDisplay.tscn"),
}

signal button_focused(index: int, button_name: String)
signal button_pressed(index: int, button_name: String)

@onready var button_container: HBoxContainer = $HBoxContainer
@onready var content_panel: ContentPanel = $CharacterContentPanel

func _ready() -> void:
  self.process_mode = Node.PROCESS_MODE_ALWAYS
  # Whenever we focus a button, we want to update the focus index.
  var children: Array[Node] = button_container.get_children()
  for i in range(children.size()):
    var button = children[i]
    button.focus_entered.connect(self._on_button_focused.bind(i, button.name))
    button.pressed.connect(self._on_button_pressed.bind(i, button.name))

    # Set our focus'n.
    button.focus_neighbor_top = button.get_path()
    button.focus_neighbor_left = children[(i - 1) % children.size()].get_path()
    button.focus_neighbor_right = children[(i + 1) % children.size()].get_path()
    button.focus_neighbor_bottom = button.get_path()

  self.focus_entered.connect(self._on_focus_entered)
  self.focus_exited.connect(self._on_focus_exited)
  self.content_panel.content_panel_closed.connect(self._on_content_panel_closed)

func _on_focus_entered() -> void:
  if content_panel.is_focused:
    content_panel.grab_focus()
    return

  button_container.get_child(PauseMenuState.character_menu_focus_index).call_deferred("grab_focus")

func _on_focus_exited() -> void:
  return

func _on_button_focused(index: int, button_name: String) -> void:
  PauseMenuState.character_menu_focus_index = index
  var content_scene: PackedScene = CONTENT_PANEL_MAPPING.get(button_name, null)
  content_panel.change_child(content_scene)
  self.button_focused.emit(index, button_name)

func _on_button_pressed(index: int, button_name: String) -> void:
  self.content_panel.grab_focus()
  self.button_pressed.emit(index, button_name)

func _on_content_panel_closed() -> void:
  button_container.get_child(PauseMenuState.character_menu_focus_index).call_deferred("grab_focus")
