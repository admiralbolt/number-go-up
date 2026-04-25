class_name InventoryDisplay extends Control

var inventory: Inventory: set = _set_inventory
var tabs: Array[InventoryTypeTab] = []

var selectable_indices: Array[int] = []
# Index index!
var index_index: int = 0

var is_focused: bool = false: set = _set_is_focused

@onready var inventory_grid: GridContainer = $PanelContainer/HBoxContainer/VBoxContainer/GridContainer
@onready var item_info: RichTextLabel = $PanelContainer/HBoxContainer/ItemInfoLabel
@onready var tab_container: HBoxContainer = $PanelContainer/HBoxContainer/VBoxContainer/TabContainer

const INVENTORY_SLOT_DISPLAY_SCENE: PackedScene = preload("res://ui/inventory/InventorySlotDisplay.tscn")

func _ready() -> void:
  SignalBus.pause_menu_closed.connect(func() -> void: self.is_focused = false)
  return

func _set_is_focused(p_is_focused: bool) -> void:
  is_focused = p_is_focused
  if not is_focused:
    return

  self.tabs[PauseMenuState.player_inventory_tab_index].select()
  self.inventory_grid.get_child(PauseMenuState.player_inventory_sub_type_focus_index.get(self.tabs[PauseMenuState.player_inventory_tab_index].item_type, 0)).grab_focus()
  
func _on_inventory_updated(item_type: Item.ItemType) -> void:
  # Update the list of selectable indices.
  self.selectable_indices.clear()
  for i in range(self.tabs.size()):
    var tab: InventoryTypeTab = self.tabs[i]
    if self.inventory.has_type(tab.item_type):
      self.selectable_indices.append(i)
      tab.deselect()
    

  # If our updated item type is the one we are currently showing, we want to
  # re-render to update the display.
  if self.tabs[PauseMenuState.player_inventory_tab_index].item_type == item_type:
    self.select_and_render()
  

func _set_inventory(p_inventory: Inventory) -> void:
  inventory = p_inventory
  self.inventory.updated.connect(self._on_inventory_updated)
  # For each of our item type tabs, make sure the neighbors are set correctly.
  # This probably doesn't need to be scripted, but doing it just in case
  # things change in the future.
  var p_tabs: Array[Node] = tab_container.get_children()
  for i in range(p_tabs.size()):
    var tab: InventoryTypeTab = p_tabs[i] as InventoryTypeTab

    self.tabs.append(tab)
    if self.inventory.has_type(tab.item_type):
      self.selectable_indices.append(i)
      tab.deselect()
  
  if self.selectable_indices.size() > 0:
    PauseMenuState.player_inventory_tab_index = self.selectable_indices[0]
    self.select_and_render()

func _unhandled_input(event: InputEvent) -> void:
  if not self.is_focused:
    return

  if event.is_action_pressed("tab_left"):
    self.tabs[PauseMenuState.player_inventory_tab_index].deselect()
    self.index_index = (self.index_index - 1) % self.selectable_indices.size()
    PauseMenuState.player_inventory_tab_index = self.selectable_indices[self.index_index]
    self.select_and_render()
    return

  if event.is_action_pressed("tab_right"):
    self.tabs[PauseMenuState.player_inventory_tab_index].deselect()
    self.index_index = (self.index_index + 1) % self.selectable_indices.size()
    PauseMenuState.player_inventory_tab_index = self.selectable_indices[self.index_index]
    self.select_and_render()
    return

func select_and_render() -> void:
  self.tabs[PauseMenuState.player_inventory_tab_index].select()
  self.render()

func render() -> void:
  var item_type: Item.ItemType = self.tabs[PauseMenuState.player_inventory_tab_index].item_type
  for child in self.inventory_grid.get_children():
    child.call_deferred("queue_free")

  var slot_list: Inventory.DynamicItemList = self.inventory.get_items(item_type)
  var all_children: Array[Node] = []
  for i in range(slot_list.size()):
    var slot: InventorySlot = slot_list.item_array[i]
    var slot_ui: InventorySlotDisplay = INVENTORY_SLOT_DISPLAY_SCENE.instantiate()
    slot_ui.slot_data = slot
    slot_ui.index = i
    slot_ui.focused.connect(self._on_slot_focused)
    slot_ui.used.connect(self._on_slot_used)
    self.inventory_grid.add_child(slot_ui)
    all_children.append(slot_ui)

  # Doing some math to set neighbors appropriately.

  var column_count: int = self.inventory_grid.columns
  var row_count: int = ceil(float(all_children.size()) / float(column_count))
  var full_matrix_size: int = row_count * column_count

  for i in range(all_children.size()):
    var child: Node = all_children[i]
    # We want focus to wrap around rows / columns nicely. Bit of a pain.
    var bottom_index: int = (i + column_count) % full_matrix_size
    if bottom_index >= all_children.size():
      bottom_index = i % column_count
    child.focus_neighbor_bottom = all_children[bottom_index].get_path()

    var top_index: int = (i - column_count) % full_matrix_size
    # Modulo beahves weirdly here, idk.
    if top_index < 0:
      top_index += full_matrix_size
    if top_index >= all_children.size():
      top_index -= column_count
    child.focus_neighbor_top = all_children[top_index].get_path()

    # Left / right we want to wrap within the row. We need to know which row
    # we are in in order to do that.
    var row_index: int = int(float(i) / column_count)
    # Subtraction behaves weirdly because of wrapping around / negative numbers,
    # so instead since we are doing modulo math, addition and subtraction are
    # inverses if we pick good numbers.
    var left_index: int = (i + column_count - 1) % column_count + row_index * column_count
    if left_index >= all_children.size():
      left_index = all_children.size() - 1
    child.focus_neighbor_left = all_children[left_index].get_path()

    var right_index: int = (i + 1) % column_count + row_index * column_count
    if right_index >= all_children.size():
      right_index = row_index * column_count
    child.focus_neighbor_right = all_children[right_index].get_path()

  if self.is_focused:
    # Seems like 2 frames is the right amount to wait. Might change depending on
    # the size of the inventory.
    await GodotUtil.wait_process_frames(get_tree(), 2)
    self.inventory_grid.get_child(PauseMenuState.player_inventory_sub_type_focus_index.get(item_type, 0)).grab_focus()

func _on_slot_focused(slot_data: InventorySlot, index: int) -> void:
  PauseMenuState.player_inventory_sub_type_focus_index[slot_data.item.item_type] = index
  self.item_info.text = slot_data.full_description()

func _on_slot_used(slot_data: InventorySlot, _index: int) -> void:
  print("Slot Used: %s" % slot_data) 
  if slot_data.item.is_usable:
    slot_data.item.use()
    self.inventory.decrement_item(slot_data.item, 1)
    return

  if slot_data.item is not Equipment:
    return

  PlayerManager.player.equipment_manager.equip(slot_data.item)
