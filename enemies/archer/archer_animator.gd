@tool
class_name ArcherAnimator extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: AnimationPlayer = $AnimationPlayer

var animation_entries: Array[AnimationEntry]

@export_tool_button("Generate Animations", "Callable") var generate_animations_action = generate_animations
@export_tool_button("Clear Animations", "Callable") var clear_animations_action = clear_animations
@export_tool_button("Debug Animations", "Callable") var debug_animations_action = debug_animations

func generate_animations() -> void:
  var direction_order: Array[String] = ["down", "downright", "right", "upright", "up", "downleft", "left", "upleft"]

  EnemyAnimator.add_animation_entries(animation_entries, "idle", "res://assets/enemies/archer/archer_idle.png", 2, direction_order, 8, 0.5, Animation.LoopMode.LOOP_LINEAR)
  EnemyAnimator.add_animation_entries(animation_entries, "walk", "res://assets/enemies/archer/archer_walk.png", 6, direction_order, 8, 0.9, Animation.LoopMode.LOOP_LINEAR)
  EnemyAnimator.add_animation_entries(animation_entries, "attack", "res://assets/enemies/archer/archer_attack.png", 5, direction_order, 8, 0.8, Animation.LoopMode.LOOP_NONE)

  EnemyAnimator.create_or_replace_animations(animator, self.get_path_to(sprite), animation_entries)

func clear_animations() -> void:
  EnemyAnimator.clear_animations(animator)

func debug_animations() -> void:
  var library: AnimationLibrary = animator.get_animation_library("EnemyAnimations")
  var anim: Animation = library.get_animation("attack_right")
  for i in range(anim.get_track_count()):
    print("track_path: %s" % anim.track_get_path(i))

