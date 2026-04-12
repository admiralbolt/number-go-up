class_name SkillSwords extends Skill

const NAME: String = "swords"

const MIN_DAMAGE_PER_LEVEL: float = 2
const MAX_DAMAGE_PER_LEVEL: float = 3
const PERCENT_DAMAGE_PER_LEVEL: float = 0.01

const SWORD_MIN_DAMAGE_INCREASE: String = "sword_min_damage_increase"
const SWORD_MAX_DAMAGE_INCREASE: String = "sword_max_damage_increase"
const SWORD_PERCENT_DAMAGE_INCREASE: String = "sword_percent_damage_increase"

@export var base_sword_min_damage_increase: float = MIN_DAMAGE_PER_LEVEL
@export var base_sword_max_damage_increase: float = MAX_DAMAGE_PER_LEVEL
@export var base_sword_percent_damage_increase: float = PERCENT_DAMAGE_PER_LEVEL

@export var sword_min_damage_increase: DerivedStatistic
@export var sword_max_damage_increase: DerivedStatistic
@export var sword_percent_damage_increase: DerivedStatistic

func _init() -> void:
  self.name = NAME

func initialize(p_entity: Entity) -> void:
  super.initialize(p_entity)

  self.sword_min_damage_increase = DerivedStatistic.make(
    SWORD_MIN_DAMAGE_INCREASE, "Min Damage Increase", base_sword_min_damage_increase, {
      Attributes.STRENGTH: 0.04,
      Attributes.DEXTERITY: 0.07
    }, p_entity
  )

  self.sword_max_damage_increase = DerivedStatistic.make(
    SWORD_MAX_DAMAGE_INCREASE, "Max Damage Increase", base_sword_max_damage_increase, {
      Attributes.STRENGTH: 0.12,
      Attributes.DEXTERITY: 0.07
    }, p_entity
  )

  self.sword_percent_damage_increase = DerivedStatistic.make(SWORD_PERCENT_DAMAGE_INCREASE, "Percent Damage Increase", base_sword_percent_damage_increase, {}, p_entity)

func level_up() -> void:
  super.level_up()

  self.base_sword_min_damage_increase = self.level * MIN_DAMAGE_PER_LEVEL
  self.sword_min_damage_increase.base_value = self.base_sword_min_damage_increase
  self.sword_min_damage_increase.compute_total()

  self.base_sword_max_damage_increase = self.level * MAX_DAMAGE_PER_LEVEL
  self.sword_max_damage_increase.base_value = self.base_sword_max_damage_increase
  self.sword_max_damage_increase.compute_total()

  self.base_sword_percent_damage_increase = self.level * PERCENT_DAMAGE_PER_LEVEL
  self.sword_percent_damage_increase.base_value = self.base_sword_percent_damage_increase
  self.sword_percent_damage_increase.compute_total()

func apply_damage_bonus(damage: float) -> float:
  return (damage + randf_range(self.sword_min_damage_increase.total_value, self.sword_max_damage_increase.total_value)) * (1 + self.sword_percent_damage_increase.total_value)

func get_sub_statistics() -> Array[DerivedStatistic]:
  return [self.sword_min_damage_increase, self.sword_max_damage_increase, self.sword_percent_damage_increase]