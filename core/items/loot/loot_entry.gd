class_name LootEntry extends Resource

@export var item_name: String
@export var weight: int
# Rarity will be used to change the overall weight depending on the rollers
# luck and/or other modifiers.
@export var rarity: float = 1
# The number of items dropped is chosen between min / max.
@export var min_items: int = 1
@export var max_items: int = 1

enum QuantityFunction {
  SIMPLE_RANDOM,
  LUCK_WEIGHTED_RANDOM,
}
@export var quantity_function: QuantityFunction = QuantityFunction.SIMPLE_RANDOM

func _init(p_item_name: String, p_weight: int, p_rarity: float, p_min_items: int, p_max_items: int, p_quantity_function: QuantityFunction = QuantityFunction.LUCK_WEIGHTED_RANDOM) -> void:
  self.item_name = p_item_name
  self.weight = p_weight
  self.rarity = p_rarity
  self.min_items = p_min_items
  self.max_items = p_max_items
  self.quantity_function = p_quantity_function

func get_items(total_luck: float) -> Array[Item]:
  if self.item_name == Item.NULL:
    return []

  var amount: int = self.min_items

  if self.min_items != self.max_items:
    if self.quantity_function == QuantityFunction.SIMPLE_RANDOM:
      amount = randi_range(self.min_items, self.max_items)
    elif self.quantity_function == QuantityFunction.LUCK_WEIGHTED_RANDOM:
      # The +1 here is to make the rounding make sense / actually be balanced.
      amount = int(MathUtil.random_weighted(self.min_items, self.max_items + 1, total_luck))

  return ItemManager.get_n_items(self.item_name, amount)
