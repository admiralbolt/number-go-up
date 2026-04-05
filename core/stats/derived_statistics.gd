"""DerivedStatistics!

Basically every computed value that applies to an entity lives here. There is
a TON of boilerplate in here, and this might be overloaded, but so far the
ModifierManager / EffectManager system works so effectively that it seems
like the best choice to just dump everything possible here.
"""
class_name DerivedStatistics extends Resource

# Bar stats.
const MAX_HEALTH: String = "max_health"
const MAX_MANA: String = "max_mana"
const MAX_STAMINA: String = "max_stamina"
const HEALTH_REGEN: String = "health_regen"
const MANA_REGEN: String = "mana_regen"
const STAMINA_REGEN: String = "stamina_regen"

# Offense!
const ATTACK_SPEED: String = "attack_speed"
const CRITICAL_GAIN: String = "critical_gain"
const CRITICAL_MULTIPLIER: String = "critical_multiplier"
const RANGE_MULTIPLIER: String = "range_multiplier"

# Defence!
const FORTITUDE_SAVE: String = "fortitude_save"
const REFLEX_SAVE: String = "reflex_save"
const WILL_SAVE: String = "will_save"
const MIND_SAVE: String = "mind_save"

const ARMOR: String = "armor"
const FORCE_RESISTANCE: String = "force_resistance"
const FIRE_RESISTANCE: String = "fire_resistance"
const COLD_RESISTANCE: String = "cold_resistance"
const LIGHTNING_RESISTANCE: String = "lightning_resistance"
const SONIC_RESISTANCE: String = "sonic_resistance"
const ACID_RESISTANCE: String = "acid_resistance"
const POISON_RESISTANCE: String = "poison_resistance"
const BLEED_RESISTANCE: String = "bleed_resistance"
const HOLY_RESISTANCE: String = "holy_resistance"
const DARK_RESISTANCE: String = "dark_resistance"

const PIERCING_REDUCTION: String = "piercing_reduction"
const SLASHING_REDUCTION: String = "slashing_reduction"
const BLUDGEONING_REDUCTION: String = "bludgeoning_reduction"
const FORCE_REDUCTION: String = "force_reduction"
const FIRE_REDUCTION: String = "fire_reduction"
const COLD_REDUCTION: String = "cold_reduction"
const LIGHTNING_REDUCTION: String = "lightning_reduction"
const SONIC_REDUCTION: String = "sonic_reduction"
const ACID_REDUCTION: String = "acid_reduction"
const POISON_REDUCTION: String = "poison_reduction"
const BLEED_REDUCTION: String = "bleed_reduction"
const HOLY_REDUCTION: String = "holy_reduction"
const DARK_REDUCTION: String = "dark_reduction"

# Misc.
const MOVEMENT_SPEED: String = "movement_speed"
const XP_MULTIPLIER: String = "xp_multiplier"

# Lucky.
const PROC_COEFFICIENT_MULTIPLIER: String = "proc_coefficient_multiplier"
const KILL_COEFFICIENT_MULTIPLIER: String = "kill_coefficient_multiplier"
const DAMAGED_COEFFICIENT_MULTIPLIER: String = "damaged_coefficient_multiplier"
const DODGE_COEFFICIENT_MULTIPLIER: String = "dodge_coefficient_multiplier"
const BLOCK_COEFFICIENT_MULTIPLIER: String = "block_coefficient_multiplier"

const ALL_DERIVED_STATISTICS: Array[String] = [
  MAX_HEALTH,
  MAX_MANA,
  MAX_STAMINA,
  HEALTH_REGEN,
  MANA_REGEN,
  STAMINA_REGEN,
  ATTACK_SPEED,
  CRITICAL_GAIN,
  CRITICAL_MULTIPLIER,
  RANGE_MULTIPLIER,
  FORTITUDE_SAVE,
  REFLEX_SAVE,
  WILL_SAVE,
  MIND_SAVE,
  ARMOR,
  FORCE_RESISTANCE,
  FIRE_RESISTANCE,
  COLD_RESISTANCE,
  LIGHTNING_RESISTANCE,
  SONIC_RESISTANCE,
  ACID_RESISTANCE,
  POISON_RESISTANCE,
  BLEED_RESISTANCE,
  HOLY_RESISTANCE,
  DARK_RESISTANCE,
  PIERCING_REDUCTION,
  SLASHING_REDUCTION,
  BLUDGEONING_REDUCTION,
  FORCE_REDUCTION,
  FIRE_REDUCTION,
  COLD_REDUCTION,
  LIGHTNING_REDUCTION,
  SONIC_REDUCTION,
  ACID_REDUCTION,
  POISON_REDUCTION,
  BLEED_REDUCTION,
  HOLY_REDUCTION,
  DARK_REDUCTION,
  MOVEMENT_SPEED,
  XP_MULTIPLIER,
  PROC_COEFFICIENT_MULTIPLIER,
  KILL_COEFFICIENT_MULTIPLIER,
  DAMAGED_COEFFICIENT_MULTIPLIER,
  DODGE_COEFFICIENT_MULTIPLIER,
  BLOCK_COEFFICIENT_MULTIPLIER
]

# Bar stats.
@export var base_max_health: float = 200.0
@export var base_max_mana: float = 100.0
@export var base_max_stamina: float = 100.0
@export var base_health_regen: float = 0.0
@export var base_mana_regen: float = 1.5
@export var base_stamina_regen: float = 3.5

# Offense!
@export var base_attack_speed: float = 1.0
@export var base_critical_gain: float = 0.01
@export var base_critical_multiplier: float = 2.0
@export var base_range_multiplier: float = 1.0
@export var base_knockback: float = 50.0

# Defence!
@export var base_fortitude_save: float = 0.0
@export var base_reflex_save: float = 0.0
@export var base_will_save: float = 0.0
@export var base_mind_save: float = 0.0

@export var base_armor: float = 0.0
@export var base_poise: float = 10.0
@export var base_force_resistance: float = 0.0
@export var base_fire_resistance: float = 0.0
@export var base_cold_resistance: float = 0.0
@export var base_lightning_resistance: float = 0.0
@export var base_sonic_resistance: float = 0.0
@export var base_acid_resistance: float = 0.0
@export var base_poison_resistance: float = 0.0
@export var base_bleed_resistance: float = 0.0
@export var base_holy_resistance: float = 0.0
@export var base_dark_resistance: float = 0.0

@export var base_piercing_reduction: float = 0.0
@export var base_slashing_reduction: float = 0.0
@export var base_bludgeoning_reduction: float = 0.0
@export var base_force_reduction: float = 0.0
@export var base_fire_reduction: float = 0.0
@export var base_cold_reduction: float = 0.0
@export var base_lightning_reduction: float = 0.0
@export var base_sonic_reduction: float = 0.0
@export var base_acid_reduction: float = 0.0
@export var base_poison_reduction: float = 0.0
@export var base_bleed_reduction: float = 0.0
@export var base_holy_reduction: float = 0.0
@export var base_dark_reduction: float = 0.0

# Misc.
@export var base_movement_speed: float = 95.0
@export var base_xp_multiplier: float = 1.0

# Lucky.
@export var base_proc_coefficient_multiplier: float = 1.0
@export var base_kill_coefficient_multiplier: float = 1.0
@export var base_damaged_coefficient_multiplier: float = 1.0
@export var base_dodge_coefficient_multiplier: float = 1.0
@export var base_block_coefficient_multiplier: float = 1.0


# Bar stats.
var max_health: DerivedStatistic
var max_mana: DerivedStatistic
var max_stamina: DerivedStatistic
var health_regen: DerivedStatistic
var mana_regen: DerivedStatistic
var stamina_regen: DerivedStatistic

# Offense!
var attack_speed: DerivedStatistic
var critical_gain: DerivedStatistic
var critical_multiplier: DerivedStatistic
var range_multiplier: DerivedStatistic
var knockback: DerivedStatistic

# Defence!
var fortitude_save: DerivedStatistic
var reflex_save: DerivedStatistic
var will_save: DerivedStatistic
var mind_save: DerivedStatistic

var armor: DerivedStatistic
var poise: DerivedStatistic
var force_resistance: DerivedStatistic
var fire_resistance: DerivedStatistic
var cold_resistance: DerivedStatistic
var lightning_resistance: DerivedStatistic
var sonic_resistance: DerivedStatistic
var acid_resistance: DerivedStatistic
var poison_resistance: DerivedStatistic
var bleed_resistance: DerivedStatistic
var holy_resistance: DerivedStatistic
var dark_resistance: DerivedStatistic

var piercing_reduction: DerivedStatistic
var slashing_reduction: DerivedStatistic
var bludgeoning_reduction: DerivedStatistic
var force_reduction: DerivedStatistic
var fire_reduction: DerivedStatistic
var cold_reduction: DerivedStatistic
var lightning_reduction: DerivedStatistic
var sonic_reduction: DerivedStatistic
var acid_reduction: DerivedStatistic
var poison_reduction: DerivedStatistic
var bleed_reduction: DerivedStatistic
var holy_reduction: DerivedStatistic
var dark_reduction: DerivedStatistic

# Misc.
var movement_speed: DerivedStatistic
var xp_multiplier: DerivedStatistic

# Lucky.
var proc_coefficient_multiplier: DerivedStatistic
var kill_coefficient_multiplier: DerivedStatistic
var damaged_coefficient_multiplier: DerivedStatistic
var dodge_coefficient_multiplier: DerivedStatistic
var block_coefficient_multiplier: DerivedStatistic


func initialize(p_entity: Entity) -> void:
  """Lord forgive me for I have sinned. This is a lot."""
  # Bar stats.
  self.max_health = DerivedStatistic.make("Max Health", base_max_health, {
    "constitution": 0.1,
    "strength": 0.03,
  }, p_entity)

  self.max_mana = DerivedStatistic.make("Max Mana", base_max_mana, {
    "intelligence": 0.1,
    "spirit": 0.04,
    "wisdom": 0.02,
    "charisma": 0.01
  }, p_entity)

  self.max_stamina = DerivedStatistic.make("Max Stamina", base_max_stamina, {
    "constitution": 0.05,
    "strength": 0.04,
    "agility": 0.03,
    "spirit": 0.02,
  }, p_entity)

  self.health_regen = DerivedStatistic.make("Health Regeneration", base_health_regen, {
    "constitution": 0.014,
    "strength": 0.007,
    "agility": 0.002
  }, p_entity)

  self.mana_regen = DerivedStatistic.make("Mana Regeneration", base_mana_regen, {
    "intelligence": 0.02,
    "spirit": 0.01,
    "wisdom": 0.01,
    "charisma": 0.005
  }, p_entity)

  self.stamina_regen = DerivedStatistic.make("Stamina Regeneration", base_stamina_regen, {
    "constitution": 0.01,
    "strength": 0.008,
    "agility": 0.006,
    "spirit": 0.004,
  }, p_entity)

  # Offense!
  self.attack_speed = DerivedStatistic.make("Attack Speed", base_attack_speed, {
    "agility": 0.008,
    "dexterity": 0.004
  }, p_entity)

  self.critical_gain = DerivedStatistic.make("Critical Gain", base_critical_gain, {
    "luck": 0.0004,
    "dexterity": 0.0002
  }, p_entity)

  self.critical_multiplier = DerivedStatistic.make("Critical Multiplier", base_critical_multiplier, {
    "luck": 0.005,
    "strength": 0.002
  }, p_entity)

  self.range_multiplier = DerivedStatistic.make("Range Multiplier", base_range_multiplier, {}, p_entity)

  self.knockback = DerivedStatistic.make("Knockback", base_knockback, {
    "strength": 0.21
  }, p_entity)

  # Defence!
  self.fortitude_save = DerivedStatistic.make("Fortitude Save", base_fortitude_save, {
    "constitution": 0.08,
    "strength": 0.03,
    "luck": 0.009
  }, p_entity)

  self.reflex_save = DerivedStatistic.make("Reflex Save", base_reflex_save, {
    "agility": 0.08,
    "dexterity": 0.03,
    "luck": 0.009
  }, p_entity)

  self.will_save = DerivedStatistic.make("Will Save", base_will_save, {
    "wisdom": 0.08,
    "spirit": 0.03,
    "luck": 0.009
  }, p_entity)

  self.mind_save = DerivedStatistic.make("Mind Save", base_mind_save, {
    "intelligence": 0.08,
    "charisma": 0.03,
    "luck": 0.009
  }, p_entity)

  self.armor = DerivedStatistic.make("Armor", base_armor, {}, p_entity)
  self.poise = DerivedStatistic.make("Poise", base_poise, {
    "constitution": 0.06,
    "strength": 0.04
  }, p_entity)
  self.force_resistance = DerivedStatistic.make("Force Resistance", base_force_resistance, {}, p_entity)
  self.fire_resistance = DerivedStatistic.make("Fire Resistance", base_fire_resistance, {}, p_entity)
  self.cold_resistance = DerivedStatistic.make("Cold Resistance", base_cold_resistance, {}, p_entity)
  self.lightning_resistance = DerivedStatistic.make("Lightning Resistance", base_lightning_resistance, {}, p_entity)
  self.sonic_resistance = DerivedStatistic.make("Sonic Resistance", base_sonic_resistance, {}, p_entity)
  self.acid_resistance = DerivedStatistic.make("Acid Resistance", base_acid_resistance, {}, p_entity)
  self.poison_resistance = DerivedStatistic.make("Poison Resistance", base_poison_resistance, {}, p_entity)
  self.bleed_resistance = DerivedStatistic.make("Bleed Resistance", base_bleed_resistance, {}, p_entity)
  self.holy_resistance = DerivedStatistic.make("Holy Resistance", base_holy_resistance, {}, p_entity)
  self.dark_resistance = DerivedStatistic.make("Dark Resistance", base_dark_resistance, {}, p_entity)

  self.piercing_reduction = DerivedStatistic.make("Piercing Reduction", base_piercing_reduction, {}, p_entity)
  self.slashing_reduction = DerivedStatistic.make("Slashing Reduction", base_slashing_reduction, {}, p_entity)
  self.bludgeoning_reduction = DerivedStatistic.make("Bludgeoning Reduction", base_bludgeoning_reduction, {}, p_entity)
  self.force_reduction = DerivedStatistic.make("Force Reduction", base_force_reduction, {}, p_entity)
  self.fire_reduction = DerivedStatistic.make("Fire Reduction", base_fire_reduction, {}, p_entity)
  self.cold_reduction = DerivedStatistic.make("Cold Reduction", base_cold_reduction, {}, p_entity)
  self.lightning_reduction = DerivedStatistic.make("Lightning Reduction", base_lightning_reduction, {}, p_entity)
  self.sonic_reduction = DerivedStatistic.make("Sonic Reduction", base_sonic_reduction, {}, p_entity)
  self.acid_reduction = DerivedStatistic.make("Acid Reduction", base_acid_reduction, {}, p_entity)
  self.poison_reduction = DerivedStatistic.make("Poison Reduction", base_poison_reduction, {}, p_entity)
  self.bleed_reduction = DerivedStatistic.make("Bleed Reduction", base_bleed_reduction, {}, p_entity)
  self.holy_reduction = DerivedStatistic.make("Holy Reduction", base_holy_reduction, {}, p_entity)
  self.dark_reduction = DerivedStatistic.make("Dark Reduction", base_dark_reduction, {}, p_entity)

  # Misc.
  self.movement_speed = DerivedStatistic.make("Movement Speed", base_movement_speed, {
    "agility": 0.1,
    "dexterity": 0.02
  }, p_entity)

  self.xp_multiplier = DerivedStatistic.make("XP Multiplier", base_xp_multiplier, {
    "luck": 0.0001
  }, p_entity)

  # Lucky.
  self.proc_coefficient_multiplier = DerivedStatistic.make("Proc Coefficient Multiplier", base_proc_coefficient_multiplier, {
    "luck": 0.0001
  }, p_entity)

  self.kill_coefficient_multiplier = DerivedStatistic.make("Kill Coefficient Multiplier", base_kill_coefficient_multiplier, {
    "luck": 0.0001
  }, p_entity)

  self.damaged_coefficient_multiplier = DerivedStatistic.make("Damaged Coefficient Multiplier", base_damaged_coefficient_multiplier, {
    "luck": 0.0001
  }, p_entity)

  self.dodge_coefficient_multiplier = DerivedStatistic.make("Dodge Coefficient Multiplier", base_dodge_coefficient_multiplier, {
    "luck": 0.0001
  }, p_entity)

  self.block_coefficient_multiplier = DerivedStatistic.make("Block Coefficient Multiplier", base_block_coefficient_multiplier, {
    "luck": 0.0001
  }, p_entity)
  

  
func debug_print() -> void:
  print("Derived Statistics:")
  for stat_name in ALL_DERIVED_STATISTICS:
    var stat: DerivedStatistic = self.get(stat_name)
    print(stat)
