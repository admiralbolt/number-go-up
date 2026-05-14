class_name InventoryDisplay extends Control

var inventory: Inventory: set = _set_inventory
var equipment_slot: Equipment.EquipmentSlot = Equipment.EquipmentSlot.UNDEFINED

@export var item_type: Item.ItemType
@export var allow_equip: bool = false

@onready var inventory_grid: GridContainer = $GridContainer
@onready var item_info: RichTextLabel = $ItemInfoLabel

var focused_index: int = -1
var focused_item: Item = null

const INVENTORY_SLOT_DISPLAY_SCENE: PackedScene = preload("res://ui/pause_menu/inventory/InventorySlotDisplay.tscn")

func _ready() -> void:
  self.focus_entered.connect(self._on_focus_entered)
  self.render()
  return
  
func _on_inventory_updated(p_item_type: Item.ItemType) -> void:
  if p_item_type != self.item_type:
    return

  self.render()

func _on_focus_entered() -> void:
  var focus_index: int = self._get_focus_index()
  if focus_index >= 0:
    self.inventory_grid.get_child(focus_index).grab_focus()

func _set_inventory(p_inventory: Inventory) -> void:
  inventory = p_inventory
  self.inventory.updated.connect(self._on_inventory_updated)

func render() -> void:
  if self.inventory == null:
    return

  for child in self.inventory_grid.get_children():
    child.call_deferred("queue_free")

  var slot_list: Inventory.DynamicItemList = self.inventory.get_items(item_type)
  if slot_list.size() == 0:
    return

  var all_children: Array[Node] = []
  var j: int = 0
  for slot in slot_list.item_array:
    if self.item_type == Item.ItemType.EQUIPMENT and self.equipment_slot != Equipment.EquipmentSlot.UNDEFINED:
      if slot.item is Equipment and slot.item.slot != self.equipment_slot:
        continue

    var slot_ui: InventorySlotDisplay = INVENTORY_SLOT_DISPLAY_SCENE.instantiate()
    slot_ui.slot_data = slot
    slot_ui.index = j
    slot_ui.focused.connect(self._on_slot_focused)
    slot_ui.used.connect(self._on_slot_used)
    self.inventory_grid.add_child(slot_ui)
    all_children.append(slot_ui)
    j += 1

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

  # Seems like 2 frames is the right amount to wait. Might change depending on
  # the size of the inventory.
  await GodotUtil.wait_process_frames(get_tree(), 2)
  var focus_index: int = self._get_focus_index()
  if focus_index >= 0:
    self.inventory_grid.get_child(focus_index).grab_focus()

func _get_focus_index() -> int:
  if self.inventory_grid.get_child_count() == 0:
    return -1

  if self.equipment_slot != Equipment.EquipmentSlot.UNDEFINED:
    var focus_index: int = PauseMenuState.player_equipment_sub_type_focus_index.get(self.equipment_slot, 0)
    if focus_index >= self.inventory_grid.get_child_count():
      PauseMenuState.player_equipment_sub_type_focus_index[self.equipment_slot] = focus_index - 1
      return focus_index - 1
    return focus_index

  var i_focus_index: int = PauseMenuState.player_inventory_sub_type_focus_index.get(self.item_type, 0)
  if i_focus_index >= self.inventory_grid.get_child_count():
    PauseMenuState.player_inventory_sub_type_focus_index[self.item_type] = i_focus_index - 1
    return i_focus_index - 1
  return i_focus_index

func _on_slot_focused(slot_data: InventorySlot, index: int) -> void:
  if self.equipment_slot != Equipment.EquipmentSlot.UNDEFINED:
    PauseMenuState.player_equipment_sub_type_focus_index[self.equipment_slot] = index
  else:
    PauseMenuState.player_inventory_sub_type_focus_index[slot_data.item.item_type] = index
  self.focused_item = slot_data.item
  self.focused_index = index
  self.item_info.text = slot_data.full_description()

func _on_slot_used(slot_data: InventorySlot, _index: int) -> void:
  if slot_data.item.is_usable:
    slot_data.item.use()
    self.inventory.decrement_item(slot_data.item, 1)
    return

  if self.allow_equip and slot_data.item is Equipment:
    # If our equipment is equipped, unequip it.
    if PlayerManager.player.equipment_manager.is_equipped(slot_data.item):
      PlayerManager.player.equipment_manager.unequip(slot_data.item)
      return

    # Otherwise put it on!
    PlayerManager.player.equipment_manager.equip(slot_data.item)

func _unhandled_input(event: InputEvent) -> void:
  if not PauseMenuState.pause_menu_open:
    return

  if self.inventory_grid.get_child_count() == 0:
    return

  if event.is_action_pressed("ui_cancel"):
    # Discard the item / equipment. For now we don't have dropped items so we
    # just decrement.
    PlayerManager.player.inventory.decrement_item(self.focused_item)
