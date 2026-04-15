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
  if owner is Player:
    var hit_event: HitEvent = HitEvent.new(owner, target, hit_box)
    SignalBus.on_player_attack_landed.emit(hit_event)
  
  var total_damage: float = 0.0
  for damage_range in hit_box.damage_ranges:
    var governing_skill: Skill = owner.skills.get(damage_range.governing_skill)
    var damage: float = randf_range(damage_range.min_damage, damage_range.max_damage)
    damage = damage if governing_skill == null else governing_skill.apply_damage_bonus(damage)

    var event: DamageEvent = DamageEvent.new(target, damage, damage_range.damage_type)
    event.owner = owner
    event.governing_skill = governing_skill

    apply_damage(event)
    total_damage += event.total_damage

  target.physics_manager.apply_knockback(hit_box)


static func apply_damage(damage_event: DamageEvent) -> void:
  # Can't deal damage to no one.
  if damage_event.target == null:
    push_error("DamageEvent has no target. Event: %s" % damage_event)
    return

  # Load our resistance / reduction.
  damage_event.resistance = damage_event.target.derived_statistics.get(DAMAGE_TYPE_TO_RESISTANCE[damage_event.damage_type]).total_value
  damage_event.reduction = damage_event.target.derived_statistics.get(DAMAGE_TYPE_TO_REDUCTION[damage_event.damage_type]).total_value

  # Emit pre_apply() after loading resistance / reduction, before damage calc.
  SignalBus.on_damage_pre_apply.emit(damage_event)

  # First we apply resistances as % reduction with logarithmic scaling.
  damage_event.total_damage = damage_event.base_damage * (100 / (100 + damage_event.resistance))
  # Then we apply flat reductions.
  damage_event.total_damage -= damage_event.reduction
  # Don't allow negative values.
  damage_event.total_damage = max(damage_event.total_damage, 0)

  if damage_event.governing_skill != null:
    damage_event.governing_skill.add_xp(damage_event.total_damage)

  damage_event.target.current_health -= damage_event.total_damage

  if damage_event.target.current_health <= 0:
    damage_event.target.kill()
    
    if damage_event.owner != null and damage_event.owner is Player:
      damage_event.owner.add_xp(damage_event.target.xp)
      # CLEAN THIS UP.
      SignalBus.on_player_killed_enemy.emit(FinalDamageEvent.make(damage_event.owner, damage_event.target, null, damage_event.total_damage))


class HitEvent:
  var owner: Entity
  var target: Entity
  var hit_box: HitBox

  func _init(p_owner: Entity, p_target: Entity, p_hit_box: HitBox) -> void:
    self.owner = p_owner
    self.target = p_target
    self.hit_box = p_hit_box

class DamageEvent:
  # REQUIRED values.
  var target: Entity
  var base_damage: float
  var damage_type: DamageType

  # Optional values that can be set by the caller or by signals.
  var owner: Entity
  var governing_skill: Skill

  # These get set automatically by calling apply_damage().
  var resistance: float
  var reduction: float
  var total_damage: float

  func _init(p_target: Entity, p_base_damage: float, p_damage_type: DamageType) -> void:
    self.target = p_target
    self.base_damage = p_base_damage
    self.damage_type = p_damage_type

  func _to_string() -> String:
    return "DamageEvent(target=%s, base_damage=%.2f, damage_type=%s, owner=%s, governing_skill=%s, resistance=%.2f, reduction=%.2f, total_damage=%.2f)" % [target.name, base_damage, str(damage_type), owner.entity_id if owner != null else "None", governing_skill.name if governing_skill != null else "None", resistance, reduction, total_damage]

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
