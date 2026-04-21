class_name Inventory extends Resource

signal updated(item_type: Item.ItemType)

@export var name: String
@export var inventory: Dictionary[Item.ItemType, DynamicItemList]

func _init() -> void:
  # Initialize our inventory structure for each of our item types.
  for item_type in Item.ItemType.values():
    inventory[item_type] = DynamicItemList.new()

func add_item(item: Item, quantity: int = 1) -> void:
  self.inventory[item.item_type].add_item(item, quantity)
  self.updated.emit(item.item_type)

func decrement_item(item: Item, count_used: int = 1) -> void:
  self.inventory[item.item_type].decrement_item(item, count_used)
  self.updated.emit(item.item_type)

func sort_by(item_type: Item.ItemType, property_name: String) -> void:
  self.inventory[item_type].sort_by(property_name)

func has_type(item_type: Item.ItemType) -> bool:
  return self.inventory[item_type].size() > 0

func get_items(item_type: Item.ItemType) -> DynamicItemList:
  return self.inventory[item_type]

class DynamicItemList extends Resource:
  # The array of items will be used for ordering in the UI.
  @export var item_array: Array[InventorySlot] = []
  # Faster tracking for existence of items. Will be keyed by item name.
  @export var item_dict: Dictionary[String, InventorySlot] = {}

  func add_item(item: Item, quantity: int = 1) -> void:
    # If our item already exists, AND is stackable, just increase the quantity.
    if item.name in self.item_dict and item.is_stackable:
      self.item_dict[item.name].quantity += quantity
      return

    var slot: InventorySlot = InventorySlot.new()
    slot.item = item
    slot.quantity = quantity
    self.item_dict[item.name] = slot
    self.item_array.append(slot)

  func decrement_item(item: Item, count_used: int = 1) -> void:
    if item.name not in self.item_dict:
      return

    self.item_dict[item.name].quantity -= count_used
    if self.item_dict[item.name].quantity > 0:
      return

    # If we used the last stack of an item, we want to clear it from our
    # tracking state, and emit a signal that it's gone so that the UI can
    # redraw itself.
    self.item_array.erase(item)
    self.item_dict[item.name].erase(item)
    SignalBus.item_removed.emit(item)

  func sort_by(property_name: String) -> void:
    self.item_array.sort_custom(func(a, b) -> int: return a.get(property_name) < b.get(property_name))
    SignalBus.items_resorted.emit()

  func size() -> int:
    return self.item_array.size()

  
class InventorySlot extends Resource:
  @export var item: Item
  @export var quantity: int
