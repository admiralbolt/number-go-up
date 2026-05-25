class_name ItemCoin extends Item

const NAME: String = "Coin"

func _init() -> void:
  self.name = NAME
  self.description = "You shouldn't ever see this..."
  self.icon = TextureManager.GENERIC_ICONS_1.make_icon(224)
  self.item_type = Item.ItemType.CURRENCY
  self.rarity = Item.ItemRarity.COMMON

  self.is_stackable = true
  self.weight = 0.001
  self.base_price = 1
  self.is_sellable = false
  self.init_uid()
