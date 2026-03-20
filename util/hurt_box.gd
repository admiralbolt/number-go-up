"""A HURT BOX FOR AN ENTITY!

For Players:
  HitBox: Should have Collision Monitoring 2 set (and nothing else).
  HurtBox: Should have Collision Layer 9 set (and nothing else).

For Enemies:
  HitBox: Should have Collision Monitoring 9 set (and nothing else).
  HurtBox: Should have Collision Layer 2 set (and nothing else).
"""
class_name HurtBox extends Area2D

@onready var entity: Entity = self.owner

func _ready() -> void:
  monitoring = false

func receive_hit(hit_box: HitBox) -> void:
  entity.take_damage(hit_box)
