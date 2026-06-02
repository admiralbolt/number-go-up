"""A HIT BOX FOR AN ATTACK!

For Players:
  HitBox: Should have Collision Mask 2 set (for enemy hurtbox) and Mask 3 (for projectile hurtbox).
  HurtBox: Should have Collision Layer 9 set (and nothing else).

For Enemies:
  HitBox: Should have Collision Mask 9 set (for player hurtbox) and Mask 3 (for projectile hurtbox).
  HurtBox: Should have Collision Layer 2 set (and nothing else).

For Projectiles:
  HurtBox: Should have Collision Layer 3 set (and nothing else).
  HitBox: Should have Collision Mask 2 set (for enemy hurtbox) and Mask 9 set (for player hurtbox).
"""
class_name HitBox extends Area2D

signal on_hit()

var owning_entity: Entity = null
var collision_shapes: Array[CollisionShape2D] = []
var hit_log: HitLog

var damage_ranges: Array[DamageRange]
var effects: Array[Effect] = []
var knockback: float

var can_hit_self: bool = false

enum KnockbackType {
  DIRECTIONAL_OUTWARD,
  FIXED,
  DIRECTIONAL_INWARD,
}

@export var knockback_type: KnockbackType = KnockbackType.DIRECTIONAL_OUTWARD
var knockback_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
  # The collision shape should always be a child of the hit box.
  for child in get_children():
    if child is CollisionShape2D:
      self.collision_shapes.append(child)

  if self.collision_shapes.size() == 0:
    push_error("HitBox: %s does not have a CollisionShape2D child." % self.name)
  
  area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
  if area is not HurtBox:
    return

  self.hit_hurt_box(area)

func hit_hurt_box(hurt_box: HurtBox) -> void:
  var hurt_box_owner = hurt_box.owner

  if not can_hit_self and hurt_box.entity.entity_id == self.owning_entity.entity_id:
    return

  if self.hit_log:
    if self.hit_log.has_hit(hurt_box_owner):
      return
    self.hit_log.log_hit(hurt_box_owner)

  self.on_hit.emit()
  hurt_box.receive_hit(self)

func enable(with_hit_logging: bool = true) -> void:
  self.monitoring = true
  if with_hit_logging:
    self.hit_log = HitLog.new()

func disable() -> void:
  self.monitoring = false

func reset() -> void:
  self.monitoring = false
  self.hit_log = null
  self.enable()

func has_hit() -> bool:
  return self.hit_log and self.hit_log.hits.size() > 0

class DamageRange extends Resource:
  @export var damage_type: Damage.DamageType
  @export var min_damage: float
  @export var max_damage: float
  @export var governing_skill: String = Skills.NULL

  static func make_without_skill(p_damage_type: Damage.DamageType, p_min_damage: float, p_max_damage: float) -> DamageRange:
    var dr = DamageRange.new()
    dr.damage_type = p_damage_type
    dr.min_damage = p_min_damage
    dr.max_damage = p_max_damage
    return dr

  static func make_with_skill(p_damage_type: Damage.DamageType, p_min_damage: float, p_max_damage: float, p_governing_skill: String) -> DamageRange:
    var dr = DamageRange.new()
    dr.damage_type = p_damage_type
    dr.min_damage = p_min_damage
    dr.max_damage = p_max_damage
    dr.governing_skill = p_governing_skill
    return dr
