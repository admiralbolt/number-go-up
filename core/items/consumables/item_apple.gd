class_name ItemApple extends Item

const NAME: String = "Apple"

const HEAL_POWER: float = 25.0

func _init() -> void:
  self.name = NAME
  self.description = "It's a fucking apple."
  self.icon = TextureManager.GENERIC_ICONS_1.make_icon(224)
  self.item_type = Item.ItemType.CONSUMABLE
  self.rarity = Item.ItemRarity.COMMON

  self.is_stackable = false
  self.weight = 0.1
  self.base_price = 1
  self.is_sellable = true

  self.is_usable = true
  self.effects = [
    InstantHealEffect.new(HEAL_POWER)
  ]
