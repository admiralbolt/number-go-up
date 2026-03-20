class_name LootTable extends Resource

@export var number_of_rolls: int = 1
@export var loot: Array[LootEntry] = []


func roll_loot(total_luck: float) -> Array[String]:
  var weight_array: Array[int] = [0]

  for entry in loot:
    weight_array.append(int(entry.weight + (total_luck * entry.rarity)) + weight_array[-1])

  var rolled_loot: Array[String] = []

  for i in range(number_of_rolls):
    var roll: int = randi() % weight_array[-1]
    rolled_loot.append(loot[weight_array.bsearch(roll) - 1].item)

  return rolled_loot

class LootEntry extends Resource:
  var item: String
  var weight: int
  # Rarity will be used to change the overall weight depending on the rollers
  # luck and/or other modifiers.
  var rarity: float = 1

  func _init(p_item: String, p_weight: int, p_rarity: float = 1) -> void:
    self.item = p_item
    self.weight = p_weight
    self.rarity = p_rarity