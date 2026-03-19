class_name HurtBox extends Area2D

@onready var entity: Entity = self.owner

func _ready() -> void:
  monitoring = false

func receive_hit(hit_box: HitBox) -> void:
  entity.take_damage(hit_box)