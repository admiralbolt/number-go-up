class_name SlimeAnimator extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: AnimationPlayer = $AnimationPlayer

@export var animation_entries: Array[AnimationEntry]

func _init() -> void:
  # Instead of doing this in the editor, we do this in here because go fast.
  var direction_order: Array[String] = ["down", "up", "left", "right"]

  EnemyAnimator.add_animation_entries(animation_entries, "idle", "res://assets/monsters/slime1/Slime1_Idle_with_shadow.png", 6, direction_order, 4, 1.0, Animation.LoopMode.LOOP_LINEAR)
  EnemyAnimator.add_animation_entries(animation_entries, "walk", "res://assets/monsters/slime1/Slime1_Walk_with_shadow.png", 8, direction_order, 4, 1.2, Animation.LoopMode.LOOP_LINEAR)
  EnemyAnimator.add_animation_entries(animation_entries, "run", "res://assets/monsters/slime1/Slime1_Run_with_shadow.png", 8, direction_order, 4, 1.0, Animation.LoopMode.LOOP_LINEAR)
  EnemyAnimator.add_animation_entries(animation_entries, "attack", "res://assets/monsters/slime1/Slime1_Attack_with_shadow.png", 10, direction_order, 4, 1.8, Animation.LoopMode.LOOP_NONE)

func _ready() -> void:
  EnemyAnimator.create_animations(animator, sprite.get_path(), animation_entries)
