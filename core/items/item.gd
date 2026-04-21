class_name Item extends Resource

enum ItemType {
  EQUIPMENT,
  CONSUMABLE,
  MATERIAL,
  CURRENCY,
  KEY_ITEMS,
  QUEST,
  TREASURE,
  PICKUP_BUFF,
  JUNK
}

const INVENTORY_ITEM_TYPES: Array[ItemType] = [
  ItemType.EQUIPMENT,
  ItemType.CONSUMABLE,
  ItemType.MATERIAL,
  ItemType.KEY_ITEMS,
  ItemType.QUEST,
  ItemType.TREASURE,
  ItemType.JUNK
]

enum ItemRarity {
  COMMON,
  UNCOMMON,
  RARE,
  EPIC,
  LEGENDARY,
  MYTHIC,
  UNIQUE,
}

static var RARITY_COLOR: Dictionary[ItemRarity, Color] = {
  ItemRarity.COMMON: Color.from_rgba8(165, 165, 165),
  ItemRarity.UNCOMMON: Color.from_rgba8(40, 210, 40),
  ItemRarity.RARE: Color.from_rgba8(40, 90, 250),
  ItemRarity.EPIC: Color.from_rgba8(80, 0, 80),
  ItemRarity.LEGENDARY: Color.from_rgba8(255, 113, 31),
  ItemRarity.MYTHIC: Color.from_rgba8(255, 51, 153),
  ItemRarity.UNIQUE: Color.from_rgba8(0, 244, 201),
}

# The name of the item! The name is used as an identifier, must be unique.
@export var name: String = ""
# The description of the item.
@export var description: String = ""
# The icon for the item.
@export var icon: SpriteSheetIcon
# The type of the item!
@export var item_type: ItemType
# The rarity of the item!
@export var rarity: ItemRarity

# Is stackable.
@export var is_stackable: bool = false
# The weight
@export var weight: float = 0.0
# Base price.
@export var base_price: float = 0.0
# Can be sold.
@export var is_sellable: bool = true

# It can be used!
@export var is_usable: bool = false
# The effects to apply!
@export var effects: Array[Effect] = []


# Called when the item is used.
func use() -> void:
  if not self.is_usable:
    return

  for effect in self.effects:
    PlayerManager.player.effect_manager.apply_effect(effect)

# Called when the item is picked up.
func on_pickup() -> void:
  return
    
