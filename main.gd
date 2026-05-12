extends Node

class SignalObject:

  var some_value: float = 10.0

signal test_signal(object: SignalObject)


class TestGenericEffect:

  func apply() -> float:
    return 0


class TestDamageEffect extends TestGenericEffect:

  var value: float

  func apply() -> float:
    return value


class TestHealEffect extends TestGenericEffect:

  var value: float

  func apply() -> float:
    return value

class TestBuffEffect extends TestGenericEffect:

  var value: float

  func apply() -> float:
    return value


class TestDataEffect:

  enum EffectType {
    DAMAGE,
    HEAL,
    BUFF
  }
  var effect_type: EffectType
  var value: float

  func apply() -> float:
    return value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  # test_signal.connect(signal_handler)
  # test_signal_stuff()
  # test_computation_speed()
  test_polymorphism()

func signal_handler(object: SignalObject) -> void:
  print("Signal handler processing.")
  object.some_value += 10
  print("Signal handler done processing.")



func test_polymorphism() -> void:
  # Construct large arrays first.
  var polymorphic_data: Array[TestGenericEffect] = []
  var data_data: Array[TestDataEffect] = []

  var start_time = Time.get_unix_time_from_system()

  for _i in range(1_000_000):
    var roll: float = randf()
    if roll < 0.3:
      var pd: TestGenericEffect = TestDamageEffect.new()
      pd.value = randf()
      polymorphic_data.append(pd)

      var td: TestDataEffect = TestDataEffect.new()
      td.effect_type = TestDataEffect.EffectType.DAMAGE
      td.value = randf()
      data_data.append(td)
      continue

    if roll < 0.6:
      var pd: TestGenericEffect = TestHealEffect.new()
      pd.value = randf()
      polymorphic_data.append(pd)

      var td: TestDataEffect = TestDataEffect.new()
      td.effect_type = TestDataEffect.EffectType.HEAL
      td.value = randf()
      data_data.append(td)
      continue

    else:
      var pd: TestGenericEffect = TestBuffEffect.new()
      pd.value = randf()
      polymorphic_data.append(pd)

      var td: TestDataEffect = TestDataEffect.new()
      td.effect_type = TestDataEffect.EffectType.BUFF
      td.value = randf()
      data_data.append(td)
      continue

  print("Data construction time for 1 million records: %s" % (Time.get_unix_time_from_system() - start_time))


  # Call apply on each record.
  start_time = Time.get_unix_time_from_system()

  for val in polymorphic_data:
    val.apply()

  print("Elapsed time for 1 million polymorphic calculations: %s" % (Time.get_unix_time_from_system() - start_time))

  start_time = Time.get_unix_time_from_system()

  for val in data_data:
    val.apply()

  print("Elapsed time for 1 million NON-polymorphic calculations: %s" % (Time.get_unix_time_from_system() - start_time))
  


func test_computation_speed() -> void:
  var start_time = Time.get_unix_time_from_system()

  # Calculate the value of a pretend derived statistics 1 million times.
  for _i in range(1_000_000):
    var _strength: float = (50.0 + 15) * 1.2

  print("Elapsed time for 1 million calculations: %s" % (Time.get_unix_time_from_system() - start_time))

  start_time = Time.get_unix_time_from_system()

  # Introduce some randomness to see how much optimization is happening.
  for _i in range(1_000_000):
    var _strength: float = (50.0 + randf()) * (1 + randf())

  print("Elapsed time for 1 million calculations with randomness: %s" % (Time.get_unix_time_from_system() - start_time))
 
   


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