class_name LootTable extends Resource

@export var number_of_rolls: int = 1
@export var loot: Array[LootEntry] = []

func _init(p_number_of_rolls: int, p_loot: Array[LootEntry]) -> void:
  self.number_of_rolls = p_number_of_rolls
  self.loot = p_loot

func roll_loot(damage_event: Damage.DamageEvent) -> Array[Item]:
  var loot_event: LootEvent = LootEvent.new(self, damage_event)
  # Emit the pre roll signal, in case we want to modify any values before loot
  # is rolled.
  SignalBus.loot_event_pre_roll.emit(loot_event)

  var weight_array: Array[int] = [0]

  for entry in loot:
    weight_array.append(int(entry.weight + (loot_event.total_luck * entry.rarity)) + weight_array[-1])

  for i in range(number_of_rolls):
    var roll: int = randi() % weight_array[-1]
    for item in loot[weight_array.bsearch(roll) - 1].get_items(loot_event.total_luck):
      loot_event.drop_items.append(item)

  # Emit the post roll signal, in case we want to modify the final list of item
  # drops.
  SignalBus.loot_event_post_roll.emit(loot_event)
  return loot_event.drop_items


# This event is triggered twice, both pre and post roll.
class LootEvent:
  # The loot table we are rolling on.
  var loot_table: LootTable
  # The damage event that caused the killin'.
  var damage_event: Damage.DamageEvent
  # The total luck at drop time.
  var total_luck: float
  # The actual items to drop.
  var drop_items: Array[Item] = []


  func _init(p_loot_table: LootTable, p_damage_event: Damage.DamageEvent) -> void:
    self.loot_table = p_loot_table
    self.damage_event = p_damage_event
    self.total_luck = p_damage_event.owner.attributes.luck.total_value
