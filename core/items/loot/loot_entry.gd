class_name LootEntry extends Resource

var item_name: String
var quantity: int
var weight: int
# Rarity will be used to change the overall weight depending on the rollers
# luck and/or other modifiers.
var rarity: float = 1

func _init(p_item_name: String, p_quantity: int, p_weight: int, p_rarity: float) -> void:
  self.item_name = p_item_name
  self.quantity = p_quantity
  self.weight = p_weight
  self.rarity = p_rarity