"""A HURT BOX FOR AN ENTITY!

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
class_name HurtBox extends Area2D

signal on_hit(hit_box: HitBox)

var entity: Entity

func _ready() -> void:
  if self.owner is Entity:
    self.entity = self.owner
  monitoring = false

func receive_hit(hit_box: HitBox) -> void:
  self.on_hit.emit(hit_box)

  if self.entity != null:
    Damage.apply_hit(hit_box.owning_entity, self.entity, hit_box)

func disable() -> void:
  self.set_collision_layer_value(2, false)
  self.set_collision_layer_value(3, false)
  self.set_collision_layer_value(9, false)
