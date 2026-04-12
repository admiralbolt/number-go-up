class_name Skill extends Resource

@export var name: String = ""
@export var level: int = 1
@export var xp: float = 0
@export var xp_multiplier: float = 1.0

var entity: Entity
var starting_xp_this_level: float = 0.0
var total_xp_to_next_level: float = RPGUtil.total_xp_for_next_skill_level(1)

const BONUS_PER_LEVEL: float = 2.0

func initialize(p_entity: Entity) -> void:
  # This is being done separate from the constructor because the attribute
  # reference may not be valid at the time of construction.
  self.entity = p_entity
  self.total_xp_to_next_level = RPGUtil.total_xp_for_next_skill_level(self.level)

func level_up() -> void:
  self.level += 1
  self.starting_xp_this_level = self.total_xp_to_next_level
  self.total_xp_to_next_level = RPGUtil.total_xp_for_next_skill_level(self.level)
  SignalBus.skill_level_up.emit(self.name, self.level)

func add_xp(amount: float) -> void:
  var event: SkillXPEvent = SkillXPEvent.make(self, amount)
  SignalBus.skill_xp_gained.emit(event)

  self.xp += event.amount * self.xp_multiplier
  if self.xp >= self.total_xp_to_next_level:
    self.level_up()
    self.changed.emit()
    return

  # Wait to call emit until after we check for level up so that we don't call
  # it twice.
  self.changed.emit()

func apply_damage_bonus(damage: float) -> float:
  return damage

func get_cooldown_reduction() -> float:
  """Returns a multiplier for total cooldown.

  This should be a number between 0 and 1.
  """
  return 1.0

func get_sub_statistics() -> Array[DerivedStatistic]:
  return []

func _to_string() -> String:
  return "%s (Level %d, XP: %.2f, Total Value: %.2f)" % [self.name, self.level, self.xp, self.total_value]

static func make(p_name: String, p_level: int, p_xp: float, p_xp_multiplier: float, p_weights: Dictionary[String, float]) -> Skill:
  var skill = Skill.new()
  skill.name = p_name
  skill.level = p_level
  skill.xp = p_xp
  skill.xp_multiplier = p_xp_multiplier
  skill.weights = p_weights
  return skill

static func make_default(p_name: String, p_weights: Dictionary[String, float]) -> Skill:
  return Skill.make(p_name, 1, 0.0, 1.0, p_weights)

class SkillXPEvent:
  var skill: Skill
  var amount: float

  static func make(p_skill: Skill, p_amount: float) -> SkillXPEvent:
    var event = SkillXPEvent.new()
    event.skill = p_skill
    event.amount = p_amount
    return event
