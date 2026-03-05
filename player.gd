class_name Player extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
  animation_player.play("PlayerAnimations/walk_down")

func _process(delta: float) -> void:
  var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
  var direction_name = Directions.get_direction_name(direction)
  animation_player.play("PlayerAnimations/%s_%s" % ["walk", direction_name])

