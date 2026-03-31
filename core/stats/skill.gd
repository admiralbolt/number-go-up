class_name Skill extends Resource

@export var name: String = ""
@export var level: int = 1
@export var xp: float = 0
@export var xp_multiplier: float = 1.0
@export var weights: Dictionary[String, float] = {}

var attr_references: Dictionary[String, Attribute] = {}
var entity: Entity
var total_value: float = self.level

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
  var val = self.level * 3
  for attr_name in self.weights.keys():
    var attribute = self.attr_references[attr_name]
    var weight = self.weights[attr_name]
    val += attribute.total_value * weight
  self.total_value = val

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