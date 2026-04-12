class_name SkillDestruction extends Skill

const NAME: String = "destruction"

const PERCENT_DAMAGE_PER_LEVEL: float = 0.01
const ABILITY_HASTE_PER_LEVEL: float = 4

const DESTRUCTION_PERCENT_DAMAGE_INCREASE: String = "destruction_percent_damage_increase"
const DESTRUCTION_ABILITY_HASTE: String = "destruction_ability_haste"

@export var base_destruction_percent_damage_increase: float = PERCENT_DAMAGE_PER_LEVEL
@export var base_destruction_ability_haste: float = ABILITY_HASTE_PER_LEVEL

@export var destruction_percent_damage_increase: DerivedStatistic
@export var destruction_ability_haste: DerivedStatistic

func _init() -> void:
  self.name = NAME

func initialize(p_entity: Entity) -> void:
  super.initialize(p_entity)

  self.destruction_percent_damage_increase = DerivedStatistic.make(
    DESTRUCTION_PERCENT_DAMAGE_INCREASE, "Percent Damage Increase", base_destruction_percent_damage_increase, {
      Attributes.INTELLIGENCE: 0.0006,
      Attributes.SPIRIT: 0.0004
    }, p_entity
  )

  self.destruction_ability_haste = DerivedStatistic.make(
    DESTRUCTION_ABILITY_HASTE, "Ability Haste", base_destruction_ability_haste, {
      Attributes.INTELLIGENCE: 0.08,
      Attributes.WISDOM: 0.07
    }, p_entity
  )

func level_up() -> void:
  super.level_up()

  self.base_destruction_percent_damage_increase = self.level * PERCENT_DAMAGE_PER_LEVEL
  self.destruction_percent_damage_increase.base_value = self.base_destruction_percent_damage_increase
  self.destruction_percent_damage_increase.compute_total()

  self.base_destruction_ability_haste = self.level * ABILITY_HASTE_PER_LEVEL
  self.destruction_ability_haste.base_value = self.base_destruction_ability_haste
  self.destruction_ability_haste.compute_total()

func apply_damage_bonus(damage: float) -> float:
  return damage * (1 + self.destruction_percent_damage_increase.total_value)

func get_cooldown_reduction() -> float:
  return 100 / (100 + self.destruction_ability_haste.total_value)

func get_sub_statistics() -> Array[DerivedStatistic]:
  return [self.destruction_percent_damage_increase, self.destruction_ability_haste]