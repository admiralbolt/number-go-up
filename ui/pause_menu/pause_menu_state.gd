extends Node

# If the content panel is focused or not.  
var content_focused: bool = false

# Which button is focused in the button menu.
var button_sidebar_focus_index: int = 0

# Which button is focused in the IO menu.
var io_menu_focus_index: int = 0

# Which button is focused in the character menu.
var character_menu_focus_index: int = 0

# Which item is selected in the attributes sub menu.
var attribute_focus_index: int = 0

# Which item is selected in the derived statistics sub menu.
var derived_statistic_focus_index: int = 0

# Which item is selected in the skills sub menu.
var skill_focus_index: int = 0

# Which item is focused in the overview sub menu.
var overview_focus_index: int = 0

# Focused tab index / item type for player inventory.
var player_inventory_tab_index: int = 0
var player_inventory_selected_item_type: Item.ItemType = Item.ItemType.EQUIPMENT

# Focused item index in sub menu for player inventory.
var player_inventory_sub_type_focus_index: Dictionary[Item.ItemType, int] = {
  Item.ItemType.CONSUMABLE: 0,
  Item.ItemType.EQUIPMENT: 0,
  Item.ItemType.MATERIAL: 0,
}