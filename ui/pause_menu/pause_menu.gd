extends CanvasLayer

@onready var content_panel: PanelContainer = $ContentPanel

@onready var primary_tab_bar: SelectableTabBar = $PrimaryTabBar
@onready var secondary_tab_bar: SelectableTabBar = $SecondaryTabBar

var first: bool = true

const SELECTABLE_ICON_SCENE: PackedScene = preload("res://ui/pause_menu/components/SelectableIcon.tscn")

#############################
### TAB INITIALIAZATION #####
#############################

static var CHARACTER_TABS: Array[TabData] = [
  TabData.new("Overview", "res://assets/ui/pause_menu/character/overview_tab.svg"),
  TabData.new("Class", "res://assets/ui/pause_menu/character/class_tab.svg"),
  TabData.new("Attributes", "res://assets/ui/pause_menu/character/attributes_tab.svg"),
  TabData.new("Statistics", "res://assets/ui/pause_menu/character/statistics_tab.svg"),
  TabData.new("Skills", "res://assets/ui/pause_menu/character/skills_tab.svg"),
]

const CHARACTER_TAB_SCENE_MAPPING: Dictionary[String, PackedScene] = {
  "Overview": preload("res://ui/pause_menu/character/CharacterOverviewDisplay.tscn"),
  "Class": preload("res://ui/pause_menu/character/CharacterClassDisplay.tscn"),
  "Attributes": preload("res://ui/pause_menu/character/CharacterAttributesDisplay.tscn"),
  "Statistics": preload("res://ui/pause_menu/character/CharacterDerivedStatisticsDisplay.tscn"),
  "Skills": preload("res://ui/pause_menu/character/CharacterSkillsDisplay.tscn"),
}

static var EQUIPMENT_TABS: Array[TabData] = [
  TabData.new("Head", "res://assets/ui/pause_menu/equip/head_slot.svg"),
  TabData.new("Body", "res://assets/ui/pause_menu/equip/body_slot.svg"),
  TabData.new("Legs", "res://assets/ui/pause_menu/equip/legs_slot.svg"),
  TabData.new("Feet", "res://assets/ui/pause_menu/equip/feet_slot.svg"),
  TabData.new("Arms", "res://assets/ui/pause_menu/equip/arms_slot.svg"),
  TabData.new("Hands", "res://assets/ui/pause_menu/equip/hands_slot.svg"),
  TabData.new("Shoulders", "res://assets/ui/pause_menu/equip/shoulders_slot.svg"),
  TabData.new("Waist", "res://assets/ui/pause_menu/equip/waist_slot.svg"),
  TabData.new("Neck", "res://assets/ui/pause_menu/equip/neck_slot.svg"),
  TabData.new("Earrings", "res://assets/ui/pause_menu/equip/earrings_slot.svg"),
  TabData.new("Ring Left", "res://assets/ui/pause_menu/equip/ring_left_slot.svg"),
  TabData.new("Ring Right", "res://assets/ui/pause_menu/equip/ring_right_slot.svg"),
  TabData.new("Weapon", "res://assets/ui/pause_menu/equip/weapon_slot.svg"),
  TabData.new("Shield", "res://assets/ui/pause_menu/equip/shield_slot.svg")
]

const EQUIPMENT_TAB_SCENE_MAPPING: Dictionary[String, PackedScene] = {
  "Head": preload("res://ui/pause_menu/inventory/EquipScreen.tscn"),
  "Body": preload("res://ui/pause_menu/inventory/EquipScreen.tscn"),
  "Legs": preload("res://ui/pause_menu/inventory/EquipScreen.tscn"),
  "Feet": preload("res://ui/pause_menu/inventory/EquipScreen.tscn"),
  "Arms": preload("res://ui/pause_menu/inventory/EquipScreen.tscn"),
  "Hands": preload("res://ui/pause_menu/inventory/EquipScreen.tscn"),
  "Shoulders": preload("res://ui/pause_menu/inventory/EquipScreen.tscn"),
  "Waist": preload("res://ui/pause_menu/inventory/EquipScreen.tscn"),
  "Neck": preload("res://ui/pause_menu/inventory/EquipScreen.tscn"),
  "Earrings": preload("res://ui/pause_menu/inventory/EquipScreen.tscn"),
  "Ring Left": preload("res://ui/pause_menu/inventory/EquipScreen.tscn"),
  "Ring Right": preload("res://ui/pause_menu/inventory/EquipScreen.tscn"),
  "Weapon": preload("res://ui/pause_menu/inventory/EquipScreen.tscn"),
  "Shield": preload("res://ui/pause_menu/inventory/EquipScreen.tscn"),
}

const EQUIPMENT_TAB_TO_SLOT_TYPE: Dictionary[String, Equipment.EquipmentSlot] = {
    "Head": Equipment.EquipmentSlot.HEAD,
    "Earrings": Equipment.EquipmentSlot.EARRINGS,
    "Shoulders": Equipment.EquipmentSlot.SHOULDERS,
    "Neck": Equipment.EquipmentSlot.NECK,
    "Body": Equipment.EquipmentSlot.BODY,
    "Shield": Equipment.EquipmentSlot.SHIELD,
    "Weapon": Equipment.EquipmentSlot.WEAPON,
    "Waist": Equipment.EquipmentSlot.WAIST,
    "Arms": Equipment.EquipmentSlot.ARMS,
    "Hands": Equipment.EquipmentSlot.HANDS,
    "Ring Left": Equipment.EquipmentSlot.RING_LEFT,
    "Ring Right": Equipment.EquipmentSlot.RING_RIGHT,
    "Legs": Equipment.EquipmentSlot.LEGS,
    "Feet": Equipment.EquipmentSlot.FEET,
}

static var INVENTORY_TABS: Array[TabData] = [
  TabData.new("Equipment", "res://assets/ui/pause_menu/inventory/equipment_tab.svg"),
  TabData.new("Consumables", "res://assets/ui/pause_menu/inventory/consumables_tab.svg"),
  TabData.new("Materials", "res://assets/ui/pause_menu/inventory/materials_tab.svg"),
  TabData.new("Quest", "res://assets/ui/pause_menu/inventory/quest_tab.svg"),
  TabData.new("Key Items", "res://assets/ui/pause_menu/inventory/key_items_tab.svg"),
  TabData.new("Treasure", "res://assets/ui/pause_menu/inventory/treasure_tab.svg"),
  TabData.new("Junk", "res://assets/ui/pause_menu/inventory/junk_tab.svg"),
]

const INVENTORY_TAB_SCENE_MAPPING: Dictionary[String, PackedScene] = {
  "Equipment": preload("res://ui/pause_menu/inventory/InventoryDisplay.tscn"),
  "Consumables": preload("res://ui/pause_menu/inventory/InventoryDisplay.tscn"),
  "Materials": preload("res://ui/pause_menu/inventory/InventoryDisplay.tscn"),
  "Quest": preload("res://ui/pause_menu/inventory/InventoryDisplay.tscn"),
  "Key Items": preload("res://ui/pause_menu/inventory/InventoryDisplay.tscn"),
  "Treasure": preload("res://ui/pause_menu/inventory/InventoryDisplay.tscn"),
  "Junk": preload("res://ui/pause_menu/inventory/InventoryDisplay.tscn"),
}

const INVENTORY_TAB_TO_ITEM_TYPE: Dictionary[String, Item.ItemType] = {
  "Equipment": Item.ItemType.EQUIPMENT,
  "Consumables": Item.ItemType.CONSUMABLE,
  "Materials": Item.ItemType.MATERIAL,
  "Quest": Item.ItemType.QUEST,
  "Key Items": Item.ItemType.KEY_ITEMS,
  "Treasure": Item.ItemType.TREASURE,
  "Junk": Item.ItemType.JUNK
}

static var IO_TABS: Array[TabData] = [
  TabData.new("Save", "res://assets/ui/pause_menu/io/save_tab.svg"),
  TabData.new("Load", "res://assets/ui/pause_menu/io/load_tab.svg"),
  TabData.new("Quit", "res://assets/ui/pause_menu/io/quit_tab.svg")
]

const IO_TAB_SCENE_MAPPING: Dictionary[String, PackedScene] = {
  "Save": preload("res://ui/pause_menu/io/SaveScreen.tscn"),
  "Load": preload("res://ui/pause_menu/io/LoadScreen.tscn"),
  "Quit": preload("res://ui/pause_menu/io/QuitScreen.tscn"),
}

static var CHARACTER_TAB_MENU_INFO: PauseMenuInfo = PauseMenuInfo.new(CHARACTER_TABS, CHARACTER_TAB_SCENE_MAPPING)
static var EQUIPMENT_TAB_MENU_INFO: PauseMenuInfo = PauseMenuInfo.new(EQUIPMENT_TABS, EQUIPMENT_TAB_SCENE_MAPPING)
static var INVENTORY_TAB_MENU_INFO: PauseMenuInfo = PauseMenuInfo.new(INVENTORY_TABS, INVENTORY_TAB_SCENE_MAPPING)
static var IO_TAB_MENU_INFO: PauseMenuInfo = PauseMenuInfo.new(IO_TABS, IO_TAB_SCENE_MAPPING)

static var TAB_MAPPING: Dictionary[String, PauseMenuInfo] = {
  "Character": CHARACTER_TAB_MENU_INFO,
  "Equipment": EQUIPMENT_TAB_MENU_INFO,
  "Inventory": INVENTORY_TAB_MENU_INFO,
  "IO": IO_TAB_MENU_INFO,
}

#############################
### END INITIALIAZATION #####
#############################


func _ready() -> void:
  self.visible = false
  self.process_mode = Node.PROCESS_MODE_ALWAYS

  self.primary_tab_bar.tab_selected.connect(self._on_primary_tab_selected)
  self.secondary_tab_bar.tab_selected.connect(self._on_secondary_tab_selected)
  SaveManager.game_loaded.connect(self._on_game_loaded)

func _on_content_panel_closed() -> void:
  PauseMenuState.primary_tab_bar_focused = true
  self.tab_bar.unfreeze()
  self.tab_bar.set_focused(true)

func _on_primary_tab_selected(index: int, tab_name: String) -> void:
  PauseMenuState.primary_tab_focus_index = index
  PauseMenuState.primary_tab_focus_name = tab_name
  
  # Update our secondary tab bar.
  self.secondary_tab_bar.clear()

  if tab_name not in TAB_MAPPING:
    self.content_panel.change_child(null)
    return

  for tab in TAB_MAPPING[tab_name].tabs:
    var new_tab: SelectableIcon = SELECTABLE_ICON_SCENE.instantiate()
    self.secondary_tab_bar.tab_container.add_child(new_tab)
    new_tab.text = tab.name
    new_tab.texture = TextureManager.load_texture(tab.texture_path)
    
  GodotUtil.wait_process_frames(get_tree(), 1)
  self.secondary_tab_bar.reload_children()
  if self.secondary_tab_bar.tabs.size() > 0:
    self.secondary_tab_bar.set_selected_index(PauseMenuState.secondary_tab_focus_index.get(tab_name, 0))

func _on_secondary_tab_selected(index: int, tab_name: String) -> void:
  PauseMenuState.secondary_tab_focus_index[PauseMenuState.primary_tab_focus_name] = index
  PauseMenuState.secondary_tab_focus_name[PauseMenuState.primary_tab_focus_name] = tab_name

  var content_scene: PackedScene = TAB_MAPPING[PauseMenuState.primary_tab_focus_name].scene_map.get(tab_name, null)
  if content_scene == null:
    self.content_panel.change_child(null)
    return
  
  var current_child: Node = null
  if self.content_panel.get_child_count() > 0:
    current_child = self.content_panel.get_child(0)

  var node: Node = content_scene.instantiate()

  if PauseMenuState.primary_tab_focus_name == "Equipment":
    if current_child is EquipScreen:
      current_child.equipment_slot = EQUIPMENT_TAB_TO_SLOT_TYPE[tab_name]
      current_child.inventory_display.render()
      return

    node.inventory = PlayerManager.player.inventory
    node.equipment_slot = EQUIPMENT_TAB_TO_SLOT_TYPE[tab_name]

  if PauseMenuState.primary_tab_focus_name == "Inventory":
    if current_child is InventoryDisplay:
      current_child.item_type = INVENTORY_TAB_TO_ITEM_TYPE[tab_name]
      current_child.render()
      return

    node.inventory = PlayerManager.player.inventory
    node.item_type = INVENTORY_TAB_TO_ITEM_TYPE[tab_name]
    node.allow_equip = false

  self.content_panel.change_child(node)

func open_menu() -> void:
  get_tree().paused = true
  self.visible = true
  PauseMenuState.pause_menu_open = true
  self.content_panel.grab_focus()

  if first:
    self.first = false
    self.primary_tab_bar.set_selected_index(0)

  SignalBus.pause_menu_opened.emit()

func close_menu() -> void:
  get_tree().paused = false
  self.visible = false
  PauseMenuState.pause_menu_open = false
  SignalBus.pause_menu_closed.emit()
  get_viewport().gui_release_focus()

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

class TabData:

  var name: String
  var texture_path: String

  func _init(p_name: String, p_texture_path: String) -> void:
    self.name = p_name
    self.texture_path = p_texture_path

class PauseMenuInfo:

  var tabs: Array[TabData]
  var scene_map: Dictionary[String, PackedScene]

  func _init(p_tabs: Array[TabData], p_scene_map: Dictionary[String, PackedScene]) -> void:
    self.tabs = p_tabs
    self.scene_map = p_scene_map
