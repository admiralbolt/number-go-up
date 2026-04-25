class_name Inventory extends Resource

signal updated(item_type: Item.ItemType)

@export var name: String
@export var inventory: Dictionary[Item.ItemType, DynamicItemList]

func _init() -> void:
  # Initialize our inventory structure for each of our item types.
  for item_type in Item.ItemType.values():
    inventory[item_type] = DynamicItemList.new()

func clear() -> void:
  for item_type in Item.ItemType.values():
    self.inventory[item_type].clear()

func add_item(item: Item, quantity: int = 1) -> void:
  self.inventory[item.item_type].add_item(item, quantity)
  self.updated.emit(item.item_type)

func decrement_item(item: Item, count_used: int = 1) -> void:
  self.inventory[item.item_type].decrement_item(item, count_used)
  self.updated.emit(item.item_type)

func sort_by(item_type: Item.ItemType, property_name: String) -> void:
  self.inventory[item_type].sort_by(property_name)

func has_type(item_type: Item.ItemType) -> bool:
  return item_type in self.inventory and self.inventory[item_type].size() > 0

func get_items(item_type: Item.ItemType) -> DynamicItemList:
  return self.inventory[item_type]

func size() -> int:
  var count: int = 0
  for item_type in Item.ItemType.values():
    count += self.inventory[item_type].size()
  return count

func serialize() -> Array[InventorySlot]:
  var slots: Array[InventorySlot] = []
  for item_type in Item.ItemType.values():
    for slot in self.inventory[item_type].item_array:
      slots.append(slot.duplicate(true))
  return slots

func load_from_list(slots: Array[InventorySlot]) -> void:
  self.clear()
  for slot in slots:
    self.add_item(slot.item, slot.quantity)

func _to_string() -> String:
  var builder: Array[String] = []
  builder.append(self.name)
  for item_type in Item.ItemType.values():
    builder.append("Type: %s" % str(item_type))
    if item_type not in self.inventory:
      builder.append("- No KEY of this type. Something bad happened.")
      continue

    for slot in self.inventory[item_type].item_array:
      builder.append("- %s x%d" % [slot.item.name, slot.quantity])

  return "\n".join(builder)

class DynamicItemList extends Resource:
  # The array of items will be used for ordering in the UI.
  @export var item_array: Array[InventorySlot] = []
  # Faster tracking for existence of items. Will be keyed by item uid.
  @export var item_dict: Dictionary[String, InventorySlot] = {}
  # Keep track of which index an item is in the array. Keyed by item uid.
  @export var item_array_indices: Dictionary[String, int] = {}

  func add_item(item: Item, quantity: int = 1) -> void:
    # If our item already exists, AND is stackable, just increase the quantity.
    if item.uid in self.item_dict and item.is_stackable:
      self.item_dict[item.uid].quantity += quantity
      return

    var slot: InventorySlot = InventorySlot.new()
    slot.item = item
    slot.quantity = quantity
    self.item_dict[item.uid] = slot
    self.item_array.append(slot)
    self.item_array_indices[item.uid] = self.item_array.size() - 1

  func decrement_item(item: Item, count_used: int = 1) -> void:
    if item.uid not in self.item_dict:
      return

    self.item_dict[item.uid].quantity -= count_used
    if self.item_dict[item.uid].quantity > 0:
      return

    # If we used the last stack of an item, we want to clear it from our
    # tracking state, and emit a signal that it's gone so that the UI can
    # redraw itself.
    self.item_array.remove_at(self.item_array_indices[item.uid])
    self.item_dict.erase(item.uid)
    self.item_array_indices.erase(item.uid)
    SignalBus.item_removed.emit(item)

  func sort_by(property_name: String) -> void:
    self.item_array.sort_custom(func(a, b) -> int: return a.get(property_name) < b.get(property_name))
    SignalBus.items_resorted.emit()

  func size() -> int:
    return self.item_array.size()

  func clear() -> void:
    self.item_array.clear()
    self.item_dict.clear()
