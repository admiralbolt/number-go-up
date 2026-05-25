class_name LootTable extends Resource

@export var number_of_rolls: int = 1
@export var loot: Array[LootEntry] = []

func _init(p_number_of_rolls: int, p_loot: Array[LootEntry]) -> void:
  self.number_of_rolls = p_number_of_rolls
  self.loot = p_loot

func roll_loot(total_luck: float) -> Array[String]:
  var weight_array: Array[int] = [0]

  for entry in loot:
    weight_array.append(int(entry.weight + (total_luck * entry.rarity)) + weight_array[-1])

  var rolled_loot: Array[String] = []

  for i in range(number_of_rolls):
    var roll: int = randi() % weight_array[-1]
    rolled_loot.append(loot[weight_array.bsearch(roll) - 1].item_name)

  return rolled_loot