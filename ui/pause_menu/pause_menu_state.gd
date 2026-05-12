extends Node

# If the pause menu is open.
var pause_menu_open: bool = false

var primary_tab_focus_index: int = 0
var primary_tab_focus_name: String = "MapTab"

var secondary_tab_focus_index: Dictionary[String, int] = {

}

var secondary_tab_focus_name: Dictionary[String, String] = {

}


# If the primary tab bar is focused.
var primary_tab_bar_focused: bool = true

# Which button is focused in the character menu.
var character_menu_focus_index: int = 0


# Which button is focused in the button menu.
var button_sidebar_focus_index: int = 0

# Which button is focused in the IO menu.
var io_menu_focus_index: int = 0


# Which item is selected in the attributes sub menu.
var attribute_focus_index: int = 0

# Which item is selected in the derived statistics sub menu.
var derived_statistic_focus_index: int = 0

# Which item is selected in the skills sub menu.
var skill_focus_index: int = 0

# Which item is focused in the overview sub menu.
var overview_focus_index: int = 0

# Focused item index in sub menu for player inventory.
var player_inventory_sub_type_focus_index: Dictionary[Item.ItemType, int] = {}

var player_equipment_sub_type_focus_index: Dictionary[Equipment.EquipmentSlot, int] = {}