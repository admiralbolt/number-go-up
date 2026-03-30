extends CanvasLayer

@onready var content_panel: PanelContainer = %ContentPanel
@onready var button_sidebar: ButtonSidebar = %ButtonSidebar

# Preload all our content panel scenes.
const CONTENT_PANEL_MAPPING: Dictionary[String, PackedScene] = {
  "IOButton": preload("res://ui/IOMenu.tscn"),
  "CharacterButton": preload("res://ui/CharacterPanel.tscn"),
}

var first: bool = true

func _ready() -> void:
  # Importantly, this needs to be run here because this script *ALSO* runs in
  # the editor.
  self.visible = false
  
  if Engine.is_editor_hint():
    return

  self.process_mode = Node.PROCESS_MODE_ALWAYS

  button_sidebar.button_focused.connect(self._on_button_focused)
  button_sidebar.button_pressed.connect(self._on_button_pressed)
  content_panel.content_panel_closed.connect(self._on_content_panel_closed)

  SaveManager.game_loaded.connect(self._on_game_loaded)

func _on_button_focused(_index: int, button_name: String) -> void:
  var content_scene: PackedScene = CONTENT_PANEL_MAPPING.get(button_name, null)
  content_panel.change_child(content_scene)

func _on_button_pressed(_index: int, _button_name: String) -> void:
  PauseMenuState.content_focused = true
  content_panel.grab_focus()

func _on_content_panel_closed() -> void:
  PauseMenuState.content_focused = false
  self.focus()

func open_menu() -> void:
  get_tree().paused = true
  self.visible = true
  SignalBus.pause_menu_opened.emit()
  self.focus()

func focus() -> void:
  if PauseMenuState.content_focused:
    content_panel.grab_focus()
    return

  button_sidebar.focus()

func close_menu() -> void:
  get_tree().paused = false
  self.visible = false
  SignalBus.pause_menu_closed.emit()

func _on_game_loaded() -> void:
  PauseMenuState.content_focused = false
  self.close_menu()

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("pause"):
    if self.visible:
      self.close_menu()
    else:
      self.open_menu()
    get_viewport().set_input_as_handled()
    return

  # If the menu isn't open OR we're focused in the sub menu, we don't want to
  # handle any input here.
  if not self.visible or PauseMenuState.content_focused:
    return

  if event.is_action_pressed("ui_cancel"):
    self.close_menu()
    get_viewport().set_input_as_handled()
    return

  if event.is_action_pressed("ui_accept"):
    PauseMenuState.content_focused = true
    self.focus()
    get_viewport().set_input_as_handled()
    return
  
