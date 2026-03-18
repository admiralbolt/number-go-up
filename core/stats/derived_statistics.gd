class_name DerivedStatistics extends Resource

@export var fortitude_save: DerivedStatistic = DerivedStatistic.make("Fortitude Save", 0.0, {
  "strength": 0.02,
  "constitution": 0.08,
})

@export var movement_speed: DerivedStatistic = DerivedStatistic.make("Movement Speed", 80.0, {
  "agility": 0.1,
  "dexterity": 0.02
})

var ALL_DERIVED_STATISTICS: Array[DerivedStatistic] = [
  fortitude_save,
  movement_speed,
]

func initialize(p_entity: Entity) -> void:
  for stat in ALL_DERIVED_STATISTICS:
    stat.initialize(p_entity)

  
func debug_print() -> void:
  print("Derived Statistics:")
  for stat in ALL_DERIVED_STATISTICS:
    print("  %s: %.2f (base: %.2f)" % [stat.name, stat.total_value, stat.base_value])


