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
  # print("Calculating damage from %s to %s with min_damage: %f, max_damage: %f, skill_bonus: %f" % [_owner.name, target.name, min_damage, max_damage, skill_bonus])
  var total_damage: float = 0.0
  for damage_range in hit_box.damage_ranges:
    var governing_skill: Skill = owner.skills.get(damage_range.governing_skill)
    var skill_bonus: float = 0.0 if governing_skill == null else governing_skill.total_value
    var damage: float = randf_range(damage_range.min_damage, damage_range.max_damage) + skill_bonus
    var resistance: DerivedStatistic = target.derived_statistics.get(DAMAGE_TYPE_TO_RESISTANCE[damage_range.damage_type])
    var reduction: DerivedStatistic = target.derived_statistics.get(DAMAGE_TYPE_TO_REDUCTION[damage_range.damage_type])

    var event: DamageCalculationEvent = DamageCalculationEvent.make(owner, target, hit_box, damage_range.damage_type, governing_skill, damage, resistance.total_value, reduction.total_value)
    SignalBus.on_damage_pre_apply.emit(event)

    # Make sure we refer to the values of the event object from here on out.

    # First we apply resistances as % reduction with logarithmic scaling.
    event.raw_damage *= (100 / (100 + event.resistance))
    # Then we apply flat reductions.
    event.raw_damage -= event.reduction
    # Don't allow negative values.
    event.raw_damage = max(event.raw_damage, 0)

    if event.governing_skill != null:
      event.governing_skill.add_xp(event.raw_damage)

    total_damage += event.raw_damage

  # Damage should be a minimum of 1.
  total_damage = max(total_damage, 1)

  var final_event: FinalDamageEvent = FinalDamageEvent.make(owner, target, hit_box, total_damage)
  
  if owner is Player:
    SignalBus.on_player_attack_landed.emit(final_event)

  if target is Player:
    SignalBus.on_player_damaged.emit(final_event)

  apply_knockback(target, hit_box)

  target.current_health -= total_damage
  target.damaged.emit(hit_box)

  if target.current_health <= 0:
    target.died.emit(hit_box)
    if owner is Player:
      owner.add_xp(target.xp)
      SignalBus.on_player_killed_enemy.emit(final_event)

static func apply_knockback(target: Entity, hit_box: HitBox) -> void:
  var total_knockback: float = hit_box.knockback * (1 - target.derived_statistics.knockback_resistance.total_value)
  var direction: Vector2 = target.global_position.direction_to(hit_box.global_position)
  target.facing = direction.normalized()
  target.velocity = -1 * direction * total_knockback
  print("Applying knockback with base knockback: %f, total_knockback: %f, resulting velocity change: %s" % [hit_box.knockback, total_knockback, target.velocity])


class DamageCalculationEvent:
  # Root objects incase we need to recalculate anything.
  var owner: Entity
  var target: Entity
  var hit_box: HitBox

  # Individual values within a single damage range.
  var damage_type: DamageType
  var governing_skill: Skill
  var raw_damage: float
  var resistance: float
  var reduction: float

  static func make(p_owner: Entity, p_target: Entity, p_hit_box: HitBox, p_damage_type: DamageType, p_governing_skill: Skill, p_raw_damage: float, p_resistance: float, p_reduction: float) -> DamageCalculationEvent:
    var event = DamageCalculationEvent.new()
    event.owner = p_owner
    event.target = p_target
    event.hit_box = p_hit_box
    event.damage_type = p_damage_type
    event.governing_skill = p_governing_skill
    event.raw_damage = p_raw_damage
    event.resistance = p_resistance
    event.reduction = p_reduction
    return event

class FinalDamageEvent:
  var owner: Entity
  var target: Entity
  var hit_box: HitBox
  var total_damage: float

  static func make(p_owner: Entity, p_target: Entity, p_hit_box: HitBox, p_total_damage: float) -> FinalDamageEvent:
    var event = FinalDamageEvent.new()
    event.owner = p_owner
    event.target = p_target
    event.hit_box = p_hit_box
    event.total_damage = p_total_damage
    return event
