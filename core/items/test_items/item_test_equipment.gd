class_name ItemTestEquipment extends Item

const NAME: String = "TestEquipment"

func _init() -> void:
  self.name = NAME
  self.description = "Test Equipment"
  self.icon = TextureManager.GENERIC_ICONS_1.make_icon(96)
  self.item_type = Item.ItemType.EQUIPMENT
  self.rarity = Item.ItemRarity.COMMON

  self.is_stackable = false
  self.weight = 0.1
  self.base_price = 1
  self.is_sellable = true

