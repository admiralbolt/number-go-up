class_name Skill extends Resource

static var SKILL_BONUS_PER_LEVEL: float = 5.0

@export var name: String = ""
@export var level: int = 1
@export var xp: float = 0.0
var base_value: float = SKILL_BONUS_PER_LEVEL
var total_value: float = SKILL_BONUS_PER_LEVEL
var xp_to_next_level: float = 1000.0
var weights: Dictionary[String, float] = {}

func _init(p_name: String, p_level: int, p_xp: float, p_weights: Dictionary[String, float]) -> void:
  self.name = p_name
  self.level = p_level
  self.base_value = level
  self.total_value = level
  self.xp = p_xp
  self.xp_to_next_level = get_xp_for_next_level()
  self.weights = p_weights

func recompute_total_value(attributes: CharacterStatistics, modifiers: Modifiers) -> void:
  self.base_value = level * SKILL_BONUS_PER_LEVEL
  for attribute_name in weights.keys():
    self.base_value += attributes.get("total_" + attribute_name) * weights[attribute_name]

  self.total_value = modifiers.compute(self.base_value, Modifiers.SubModifier.TargetType.Skill, self.name)

func get_xp_for_next_level() -> float:
  return 500 * (level ** 2.4 + level ** 1.7 + level ** 1.2)

func add_xp(amount: float) -> void:
  xp += amount
  while xp >= xp_to_next_level:
    level += 1
    xp_to_next_level = get_xp_for_next_level()
    SignalBus.skill_level_up.emit(name, level)

func debug_print() -> void:
  print("%s: (Level %d, XP %.2f, Base Value: %.2f, Total Value %.2f)" % [name, level, xp, base_value, total_value])