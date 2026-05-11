class_name CharacterPanel extends Control

# Preload all our sub panel scene.
const CONTENT_PANEL_MAPPING: Dictionary[String, PackedScene] = {
  "OverviewTab": preload("res://ui/pause_menu/CharacterOverviewDisplay.tscn"),
  "ClassTab": preload("res://ui/pause_menu/CharacterClassDisplay.tscn"),
  "AttributesTab": preload("res://ui/pause_menu/CharacterAttributesDisplay.tscn"),
  "StatisticsTab": preload("res://ui/pause_menu/CharacterDerivedStatisticsDisplay.tscn"),
  "SkillsTab": preload("res://ui/pause_menu/CharacterSkillsDisplay.tscn"),
}

@onready var tab_bar: SelectableTabBar = $CharacterTabBar
@onready var content_panel: ContentPanel = $CharacterContentPanel

func _ready() -> void:
  self.process_mode = Node.PROCESS_MODE_ALWAYS
  # Whenever we focus a button, we want to update the focus index.
  self.tab_bar.tab_selected.connect(self._on_tab_selected)
  self.tab_bar.tab_activated.connect(self._on_tab_activated)

  self.focus_entered.connect(self._on_focus_entered)
  self.focus_exited.connect(self._on_focus_exited)
  self.content_panel.closed.connect(self._on_content_panel_closed)

  self.tab_bar.set_selected_index(PauseMenuState.character_menu_focus_index, false)

func _on_focus_entered() -> void:
  if content_panel.is_focused:
    self.tab_bar.set_focused(false)
    content_panel.grab_focus()
    return

  self.tab_bar.set_focused(true)

func _on_focus_exited() -> void:
  return

func _on_tab_selected(index: int, tab_name: String) -> void:
  PauseMenuState.character_menu_focus_index = index
  var content_scene: PackedScene = CONTENT_PANEL_MAPPING.get(tab_name, null)
  content_panel.change_child(content_scene)

func _on_tab_activated(_index: int, tab_name: String) -> void:
  if tab_name in CONTENT_PANEL_MAPPING:
    self.tab_bar.freeze()
  
  self.content_panel.grab_focus()

func _on_content_panel_closed() -> void:
  self.tab_bar.unfreeze()
  self.tab_bar.set_focused(true)
