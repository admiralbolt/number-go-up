@tool
class_name PlayerAnimator extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: AnimationPlayer = $AnimationPlayer

var sprite_path: NodePath
var sprite_frame_path: NodePath
var animation_entries: Array[AnimationEntry]

@export_tool_button("Generate Animations", "Callable") var generate_animations_action = generate_animations
@export_tool_button("Clear Animations", "Callable") var clear_animations_action = clear_animations
@export_tool_button("Debug Animations", "Callable") var debug_animations_action = debug_animations

static var ACTIONS: Array[String] = ["walk", "roll", "attack", "idle"]
static var ANIMATION_DURATION: Dictionary[String, float] = {
  "walk": 0.6,
  "roll": 0.4,
  "attack": 0.5,
  "idle": 0.6
}
static var ANIMATION_LOOP_MODE: Dictionary[String, Animation.LoopMode] = {
  "walk": Animation.LoopMode.LOOP_LINEAR,
  "roll": Animation.LoopMode.LOOP_NONE,
  "attack": Animation.LoopMode.LOOP_NONE,
  "idle": Animation.LoopMode.LOOP_LINEAR
}

func create_animation(frame_indices: Array[int], duration: float = 0.6, loop_mode: Animation.LoopMode = Animation.LoopMode.LOOP_LINEAR) -> Animation:
  var anim = Animation.new()
  anim.length = duration
  anim.loop_mode = loop_mode

  var frame_track_id: int = anim.add_track(Animation.TYPE_VALUE)
  anim.track_set_path(frame_track_id, sprite_frame_path)
  anim.value_track_set_update_mode(frame_track_id, Animation.UPDATE_DISCRETE)

  for i in range(frame_indices.size()):
    var time: float = (i / float(frame_indices.size())) * duration
    anim.track_insert_key(frame_track_id, time, frame_indices[i])

  return anim

func generate_animations() -> void:
  var parent_node: Node = self.get_parent()
  self.sprite_path = parent_node.get_path_to(sprite)
  self.sprite_frame_path = "%s:frame" % self.sprite_path
  var frame: int = 0
  var animation_library: AnimationLibrary = AnimationLibrary.new()
  for action in ACTIONS:
    for direction in ["down", "downright", "right", "upright", "up", "upleft", "left", "downleft"]:
      var anim_name: String = "%s_%s" % [action, direction]
      var frame_indices: Array[int] = [frame, frame + 1, frame + 2, frame + 3]
      var loop_mode: Animation.LoopMode = ANIMATION_LOOP_MODE[action]

      var anim: Animation = self.create_animation(frame_indices, ANIMATION_DURATION[action], loop_mode)
      animation_library.add_animation(anim_name, anim)
      frame += 4

  animator.add_animation_library("PlayerAnimations", animation_library)

func clear_animations() -> void:
  animator.remove_animation_library("PlayerAnimations")

func debug_animations() -> void:
  var library: AnimationLibrary = animator.get_animation_library("PlayerAnimations")
  var anim: Animation = library.get_animation("roll_downleft")
  for i in range(anim.get_track_count()):
    print("track_path: %s" % anim.track_get_path(i))

