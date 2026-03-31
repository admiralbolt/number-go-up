class_name Skill extends Resource

@export var name: String = ""
@export var level: int = 1
@export var xp: float = 0
@export var xp_multiplier: float = 1.0
@export var weights: Dictionary[String, float] = {}

var attr_references: Dictionary[String, Attribute] = {}
var entity: Entity
var total_value: float = self.level
var starting_xp_this_level: float = 0.0
var total_xp_to_next_level: float = 1000.0

const BONUS_PER_LEVEL: float = 2.0

func initialize(p_entity: Entity) -> void:
  # This is being done separate from the constructor because the attribute
  # reference may not be valid at the time of construction.
  self.entity = p_entity
  for attr_name in self.weights.keys():
    var attribute: Attribute = p_entity.attributes.get(attr_name)
    self.attr_references[attr_name] = attribute
    # When any of the attributes that affect this statistic change, we need to
    # recompute the total value.
    if not attribute.is_connected("changed", self.compute_total):
      attribute.changed.connect(self.compute_total)
  self.compute_total()

func compute_total() -> void:
  var val = self.level * BONUS_PER_LEVEL
  for attr_name in self.weights.keys():
    var attribute = self.attr_references[attr_name]
    var weight = self.weights[attr_name]
    val += attribute.total_value * weight

  var new_total: float = self.entity.modifier_manager.compute_total(self.name, val)
  if new_total == self.total_value:
    return
  
  self.total_value = val
  self.changed.emit()

func compute_total_description() -> Array[String]:
  var builder: Array[String] = []
  var val = self.level * BONUS_PER_LEVEL
  builder.append("Base (Level * %d): %.2f" % [BONUS_PER_LEVEL, val])
  for attr_name in self.weights.keys():
    var attribute: Attribute = self.attr_references[attr_name]
    var weight: float = self.weights[attr_name]
    var new_val: float = val + attribute.total_value * weight

    builder.append("%s (%s%%):\n\t%.2f -> %.2f" % [attr_name.capitalize(), weight * 100, val, new_val])

    val = new_val

  for line in self.entity.modifier_manager.compute_total_description(self.name, val):
    builder.append(line)

  return builder

func level_up() -> void:
  self.level += 1
  self.starting_xp_this_level = self.xp
  self.total_xp_to_next_level = RPGUtil.total_xp_for_next_skill_level(self.level)
  self.compute_total()

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
