"""Creates a bunch of items for testing purposes!"""
class_name TestItemManager extends Node

static var is_initialized: bool = false
static var frame: int = 0

static var all_test_items: Array[Item] = []

static func get_item() -> Item:
  var item: Item = TestItemManager.all_test_items.pick_random()
  item.init_uid()
  return item

static func initialize() -> void: 
  if is_initialized:
    return

  for _i in range(150):
    all_test_items.append(make_next())

  is_initialized = true

static func make_next() -> Item:
  if Item.INVENTORY_ITEM_TYPES[frame % Item.INVENTORY_ITEM_TYPES.size()] == Item.ItemType.EQUIPMENT:
    return make_next_equipment()

  return make_next_item()

static func make_next_equipment() -> Equipment:
  var item: Equipment = Equipment.new()

  item.name = GeneratorUtil.generate_random_word()
  
  item.description = GeneratorUtil.generate_paragraph()
  item.icon = TextureManager.GENERIC_ICONS_1.make_icon(frame)
  item.rarity = Item.ItemRarity.values().pick_random()
  item.item_type = Item.ItemType.EQUIPMENT
  item.slot = Equipment.EquipmentSlot.values().pick_random()

  item.is_stackable = true if randf() < 0.5 else false
  item.weight = randf_range(0.1, 100.0)
  item.base_price = randf_range(1, 10_000)
  item.is_sellable = true if randf() < 0.6 else false
  item.init_uid()

  frame += 1
  return item

static func make_next_item() -> Item:
  var item: Item = Item.new()
  item.name = GeneratorUtil.generate_random_word()
  
  item.description = GeneratorUtil.generate_paragraph()
  item.icon = TextureManager.GENERIC_ICONS_1.make_icon(frame)
  item.rarity = Item.ItemRarity.values().pick_random()
  item.item_type = Item.INVENTORY_ITEM_TYPES[frame % Item.INVENTORY_ITEM_TYPES.size()]

  item.is_stackable = true if randf() < 0.5 else false
  item.weight = randf_range(0.1, 100.0)
  item.base_price = randf_range(1, 10_000)
  item.is_sellable = true if randf() < 0.6 else false
  item.init_uid()

  frame += 1
  return item