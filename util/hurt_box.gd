class_name HurtBox extends Area2D

@onready var owner_stats: CharacterStatistics = owner.stats

func _ready() -> void:
  monitoring = false

  set_collision_layer_value(1, false)
  set_collision_mask_value(1, false)
  set_collision_layer_value(GodotUtil.ENEMY_LAYER, true)

func receive_hit(damage: float) -> void:
  owner_stats.current_hp -= damage