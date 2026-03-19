class_name HurtBox extends Area2D

@onready var entity: Entity = self.owner

func _ready() -> void:
  monitoring = false

  set_collision_layer_value(1, false)
  set_collision_mask_value(1, false)
  set_collision_layer_value(GodotUtil.ENEMY_LAYER, true)

func receive_hit(hit_box: HitBox) -> void:
  entity.take_damage(hit_box)