"""A HURT BOX FOR AN ENTITY!

For Players:
  HitBox: Should have Collision Monitoring 2 set (and nothing else).
  HurtBox: Should have Collision Layer 9 set (and nothing else).

For Enemies:
  HitBox: Should have Collision Monitoring 9 set (and nothing else).
  HurtBox: Should have Collision Layer 2 set (and nothing else).
"""
class_name HurtBox extends Area2D

signal on_hit()

var entity: Entity

func _ready() -> void:
  if self.owner is Entity:
    self.entity = self.owner
  monitoring = false

func receive_hit(hit_box: HitBox) -> void:
  self.on_hit.emit()

  if self.entity != null:
    Damage.apply_hit(hit_box.owning_entity, self.entity, hit_box)
    return

func disable() -> void:
  self.set_collision_layer_value(2, false)
  self.set_collision_layer_value(9, false)
