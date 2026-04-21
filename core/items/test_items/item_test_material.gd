class_name ItemTestMaterial extends Item

const NAME: String = "TestMaterial"

func _init() -> void:
  self.name = NAME
  self.description = "Test Material"
  self.icon = TextureManager.GENERIC_ICONS_1.make_icon(92)
  self.item_type = Item.ItemType.MATERIAL
  self.rarity = Item.ItemRarity.COMMON

  self.is_stackable = true
  self.weight = 0.1
  self.base_price = 1
  self.is_sellable = true

