class_name DerivedStatistics extends Resource

@export var fortitude_save: DerivedStatistic = DerivedStatistic.make("Fortitude Save", 0.0, {
  "strength": 0.02,
  "constitution": 0.08,
})

var ALL_DERIVED_STATISTICS: Array[DerivedStatistic] = [
  fortitude_save,
]

func initialize(p_entity: Entity) -> void:
  for stat in ALL_DERIVED_STATISTICS:
    stat.initialize(p_entity)

  
func debug_print() -> void:
  print("Derived Statistics:")
  for stat in ALL_DERIVED_STATISTICS:
    print("  %s: %.2f (base: %.2f)" % [stat.name, stat.total_value, stat.base_value])


