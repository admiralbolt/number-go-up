extends Node

class SignalObject:

  var some_value: float = 10.0

signal test_signal(object: SignalObject)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  test_signal.connect(signal_handler)
  test_signal_stuff()

func signal_handler(object: SignalObject) -> void:
  print("Signal handler processing.")
  object.some_value += 10
  print("Signal handler done processing.")


func test_signal_stuff() -> void:
  var object: SignalObject = SignalObject.new()
  object.some_value = 25
  print("Emitting signal with object some_value: ", object.some_value)
  test_signal.emit(object)
  print("After signal emitted, object some_value: ", object.some_value)


func test_new_char_stuff() -> void:
  var hero = Entity.new()

  hero.debug_print()

  var m: Modifier = Modifier.new()
  m.source_name = "FIRE MANG"
  m.source_type = Modifier.ModifierSource.SPELL
  m.target_type = Modifier.ModifierTarget.ATTRIBUTE
  m.stat_name = Attributes.STRENGTH
  m.value = 5
  m.is_decaying = true

  var b: BuffEffect = BuffEffect.new()
  b.modifier = m
  b.duration = 10.0

  hero.effect_manager.apply_effect(b)

  hero.debug_print()

  # Sleep for 5 seconds to let the effect tick down.
  await get_tree().create_timer(5.0).timeout

  hero.debug_print()



func test_loot_pool() -> void:
  var loot_table = LootTable.new()
  loot_table.number_of_rolls = 3
  loot_table.loot.append(LootTable.LootEntry.new("Sword of Flames", 10, 1.5))
  loot_table.loot.append(LootTable.LootEntry.new("Shield of Ice", 50, 0.1))
  loot_table.loot.append(LootTable.LootEntry.new("Potion of Healing", 100, -0.1))


  for luck in [10, 50, 100]:
    print("Rolling loot with total luck: ", luck, loot_table.roll_loot(luck))