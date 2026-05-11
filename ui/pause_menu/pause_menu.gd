extends CanvasLayer

@onready var content_panel: PanelContainer = $ContentPanel
@onready var tab_bar: SelectableTabBar = $PauseMenuPrimaryTabBar

var first: bool = true

# Preload all our content panel scenes.
const CONTENT_PANEL_MAPPING: Dictionary[String, PackedScene] = {
  "IOTab": preload("res://ui/pause_menu/IOMenu.tscn"),
  "CharacterTab": preload("res://ui/pause_menu/character/CharacterPanel.tscn"),
  "InventoryTab": preload("res://ui/pause_menu/InventoryPanel.tscn"),
}

func _ready() -> void:
  self.visible = false
  self.process_mode = Node.PROCESS_MODE_ALWAYS

  self.tab_bar.tab_selected.connect(self._on_tab_selected)
  self.tab_bar.tab_activated.connect(self._on_tab_activated)
  self.tab_bar.tab_bar_exit.connect(self._on_tab_bar_exited)

  self.content_panel.closed.connect(self._on_content_panel_closed)

  SaveManager.game_loaded.connect(self._on_game_loaded)

  self.tab_bar.set_focused(true)

func _on_content_panel_closed() -> void:
  PauseMenuState.primary_tab_bar_focused = true
  self.tab_bar.unfreeze()
  self.tab_bar.set_focused(true)

func _on_tab_selected(_index: int, tab_name: String) -> void:
  var content_scene: PackedScene = CONTENT_PANEL_MAPPING.get(tab_name, null)
  self.content_panel.change_child(content_scene)

func _on_tab_activated(_index: int, tab_name: String) -> void:
  if tab_name not in CONTENT_PANEL_MAPPING:
    return
  
  self.tab_bar.freeze()
  self.tab_bar.set_focused(false)
  PauseMenuState.primary_tab_bar_focused = false
  self.content_panel.grab_focus()

func _on_tab_bar_exited() -> void:
  self.close_menu()

func open_menu() -> void:
  get_tree().paused = true
  self.focus()
  self.visible = true
  SignalBus.pause_menu_opened.emit()

func close_menu() -> void:
  get_tree().paused = false
  self.visible = false
  SignalBus.pause_menu_closed.emit()

func focus() -> void:
  if PauseMenuState.primary_tab_bar_focused:
    self.tab_bar.set_focused(true)
    return

  self.content_panel.grab_focus()

func _on_game_loaded() -> void:
  self.close_menu()

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("pause"):
    if self.visible:
      self.close_menu()
    else:
      self.open_menu()
    get_viewport().set_input_as_handled()
    return
