"""Classes!"""
class_name CharacterClass extends Resource

static var SKILL_POINT_BUCKET_SIZE: int = 25

@export var name: String

@export var stat_ordering: StatOrdering
@export var skill_tree: SkillTree

@export var level: int = 1
@export var available_skill_points: int = 1
@export var total_skill_points: int = 1
@export var total_skill_points_from_levels: int = 1
@export var levels_since_skill_point: int = 0

@export var health_per_level: float
@export var mana_per_level: float
@export var stamina_per_level: float

func _ready() -> void:
  SignalBus.skill_node_rank_up.connect(self._on_skill_node_rank_up)
  SignalBus.skill_node_rank_down.connect(self._on_skill_node_rank_down)

func _on_skill_node_rank_up(_skill_node_name: String, _new_rank: int) -> void:
  self.available_skill_points -= 1

func _on_skill_node_rank_down(_skill_node_name: String, _new_rank: int) -> void:
  self.available_skill_points += 1

func level_up() -> void:
  for attr_name in self.stat_ordering.stat_weights:
    PlayerManager.player.attributes.get(attr_name).value += RPGUtil.get_attribute_level_bonus(PlayerManager.player.level, self.stat_ordering.stat_weights[attr_name])

  self.level += 1
  if self.should_gain_skill_point():
    self.available_skill_points += 1
    self.total_skill_points += 1
    self.total_skill_points_from_levels += 1

  PlayerManager.player.derived_statistics.max_health.base_value += self.health_per_level
  PlayerManager.player.derived_statistics.max_stamina.base_value += self.stamina_per_level
  PlayerManager.player.derived_statistics.max_mana.base_value += self.mana_per_level

func should_gain_skill_point() -> bool:
  """A rough outline of the maths here:

  We want the rate at which skill points are given to slowly decrease.
    - First 20 skill points are 1 level each.
    - Next 20 skill points are 2 levels each.
    - Next 20 skill points are 3 levels each, e.t.c.

  The actual bucket size is determined by the static var above.
  """
  @warning_ignore("integer_division")
  var bucket: int = (self.total_skill_points_from_levels - 1) / SKILL_POINT_BUCKET_SIZE

  if bucket <= self.levels_since_skill_point:
    self.levels_since_skill_point = 0
    return true

  self.levels_since_skill_point += 1
  return false