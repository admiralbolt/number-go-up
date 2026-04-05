class_name Damage extends RefCounted

enum DamageType {
  # Physical types
  SLASHING,
  PIERCING,
  BLUDGEONING,

  # Magical/status types
  FIRE,
  ICE,
  LIGHTNING,
  POISON,
  ACID,
  BLEED,
  FORCE,
  HOLY,
  DARK,

  # True damage ignores all defenses
  TRUE,
}

# Resistances are % damage reduction.
static var DAMAGE_TYPE_TO_RESISTANCE: Dictionary[DamageType, String] = {
  DamageType.SLASHING: DerivedStatistics.ARMOR,
  DamageType.PIERCING: DerivedStatistics.ARMOR,
  DamageType.BLUDGEONING: DerivedStatistics.ARMOR,
  DamageType.FIRE: DerivedStatistics.FIRE_RESISTANCE,
  DamageType.ICE: DerivedStatistics.COLD_RESISTANCE,
  DamageType.LIGHTNING: DerivedStatistics.LIGHTNING_RESISTANCE,
  DamageType.POISON: DerivedStatistics.POISON_RESISTANCE,
  DamageType.ACID: DerivedStatistics.ACID_RESISTANCE,
  DamageType.BLEED: DerivedStatistics.BLEED_RESISTANCE,
  DamageType.FORCE: DerivedStatistics.FORCE_RESISTANCE,
  DamageType.HOLY: DerivedStatistics.HOLY_RESISTANCE,
  DamageType.DARK: DerivedStatistics.DARK_RESISTANCE,
}

# Reductions are flat damage reduction, applied after resistance.
static var DAMAGE_TYPE_TO_REDUCTION: Dictionary[DamageType, String] = {
  DamageType.SLASHING: DerivedStatistics.SLASHING_REDUCTION,
  DamageType.PIERCING: DerivedStatistics.PIERCING_REDUCTION,
  DamageType.BLUDGEONING: DerivedStatistics.BLUDGEONING_REDUCTION,
  DamageType.FIRE: DerivedStatistics.FIRE_REDUCTION,
  DamageType.ICE: DerivedStatistics.COLD_REDUCTION,
  DamageType.LIGHTNING: DerivedStatistics.LIGHTNING_REDUCTION,
  DamageType.POISON: DerivedStatistics.POISON_REDUCTION,
  DamageType.ACID: DerivedStatistics.ACID_REDUCTION,
  DamageType.BLEED: DerivedStatistics.BLEED_REDUCTION,
  DamageType.FORCE: DerivedStatistics.FORCE_REDUCTION,
  DamageType.HOLY: DerivedStatistics.HOLY_REDUCTION,
  DamageType.DARK: DerivedStatistics.DARK_REDUCTION,
}

static func apply_hit(owner: Entity, target: Entity, hit_box: HitBox) -> void:
  # Eventually we'll probably want other stuff from the owner. For right now
  # I can't think of anything direct.
  # print("Calculating damage from %s to %s with min_damage: %f, max_damage: %f, skill_bonus: %f" % [_owner.name, target.name, min_damage, max_damage, skill_bonus])
  var total_damage: float = 0.0
  for damage_range in hit_box.damage_ranges:
    var governing_skill: Skill = owner.skills.get(damage_range.governing_skill)
    var skill_bonus: float = 0.0 if governing_skill == null else governing_skill.total_value
    var damage: float = randf_range(damage_range.min_damage, damage_range.max_damage) + skill_bonus
    var resistance: DerivedStatistic = target.derived_statistics.get(DAMAGE_TYPE_TO_RESISTANCE[damage_range.damage_type])
    var reduction: DerivedStatistic = target.derived_statistics.get(DAMAGE_TYPE_TO_REDUCTION[damage_range.damage_type])

    # First we apply resistances as % reduction with logarithmic scaling.
    damage *= (100 / (100 + resistance.total_value))
    # Then we apply flat reductions.
    damage -= reduction.total_value
    # Don't allow negative values.
    damage = max(damage, 0)

    if governing_skill != null:
      governing_skill.add_xp(damage)

    total_damage += damage

  # Damage should be a minimum of 1.
  total_damage = max(total_damage, 1)

  target.current_health -= total_damage
  target.damaged.emit(hit_box)

  if target.current_health <= 0:
    target.died.emit(hit_box)
