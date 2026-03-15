class_name WeaponAnimator extends AnimationPlayer

@onready var weapon: Node2D = $"../../Weapon"
@onready var anim_root_node: Node = self.get_node(self.root_node)
@onready var weapon_path: NodePath = anim_root_node.get_path_to(weapon)
@onready var weapon_visible_path: NodePath = "%s:visible" % weapon_path
@onready var weapon_position_path: NodePath = "%s:position" % weapon_path
@onready var weapon_rotation_path: NodePath = "%s:rotation" % weapon_path

# Will eventually need to abstract this a bit, but for now let's test
# this manually / semi-randomly to see what's what.
var POSITIONS: Dictionary[String, KeyFrameDataList] = {
  "down": KeyFrameDataList.new([
    KeyFrameData.new(Vector2(-4.1, 1.7), MathUtil.degrees_to_radians(-90)),
    KeyFrameData.new(Vector2(0.5, 4.6), MathUtil.degrees_to_radians(-135)),
    KeyFrameData.new(Vector2(5.1, 7.5), MathUtil.degrees_to_radians(-180)),
    KeyFrameData.new(Vector2(5.1, 7.5), MathUtil.degrees_to_radians(-180)),
    KeyFrameData.new(Vector2(5.1, 7.5), MathUtil.degrees_to_radians(-180)),
    KeyFrameData.new(Vector2(5.1, 7.5), MathUtil.degrees_to_radians(-180)),
    KeyFrameData.new(Vector2(5.1, 7.5), MathUtil.degrees_to_radians(-180)),
    KeyFrameData.new(Vector2(5.1, 7.5), MathUtil.degrees_to_radians(-180)),
  ]),
  "downleft": KeyFrameDataList.new([
    KeyFrameData.new(Vector2(-4.1, 1.7), MathUtil.degrees_to_radians(-90)),
    KeyFrameData.new(Vector2(0.5, 4.6), MathUtil.degrees_to_radians(-135)),
    KeyFrameData.new(Vector2(5.1, 7.5), MathUtil.degrees_to_radians(-180)),
    KeyFrameData.new(Vector2(5.1, 7.5), MathUtil.degrees_to_radians(-180)),
    KeyFrameData.new(Vector2(5.1, 7.5), MathUtil.degrees_to_radians(-180)),
    KeyFrameData.new(Vector2(5.1, 7.5), MathUtil.degrees_to_radians(-180)),
    KeyFrameData.new(Vector2(5.1, 7.5), MathUtil.degrees_to_radians(-180)),
    KeyFrameData.new(Vector2(5.1, 7.5), MathUtil.degrees_to_radians(-180)),
  ]),
  "left": KeyFrameDataList.new([
    KeyFrameData.new(Vector2(0, -6.5), MathUtil.degrees_to_radians(0)),
    KeyFrameData.new(Vector2(-3.05, -2.4), MathUtil.degrees_to_radians(-45)),
    KeyFrameData.new(Vector2(-6.1, 1.7), MathUtil.degrees_to_radians(-90)),
    KeyFrameData.new(Vector2(-6.1, 1.7), MathUtil.degrees_to_radians(-90)),
    KeyFrameData.new(Vector2(-6.1, 1.7), MathUtil.degrees_to_radians(-90)),
    KeyFrameData.new(Vector2(-6.1, 1.7), MathUtil.degrees_to_radians(-90)),
    KeyFrameData.new(Vector2(-6.1, 1.7), MathUtil.degrees_to_radians(-90)),
    KeyFrameData.new(Vector2(-6.1, 1.7), MathUtil.degrees_to_radians(-90)),
  ]),
  "upleft": KeyFrameDataList.new([
    KeyFrameData.new(Vector2(0, -6.5), MathUtil.degrees_to_radians(0)),
    KeyFrameData.new(Vector2(-3.05, -2.4), MathUtil.degrees_to_radians(-45)),
    KeyFrameData.new(Vector2(-6.1, 1.7), MathUtil.degrees_to_radians(-90)),
    KeyFrameData.new(Vector2(-6.1, 1.7), MathUtil.degrees_to_radians(-90)),
    KeyFrameData.new(Vector2(-6.1, 1.7), MathUtil.degrees_to_radians(-90)),
    KeyFrameData.new(Vector2(-6.1, 1.7), MathUtil.degrees_to_radians(-90)),
    KeyFrameData.new(Vector2(-6.1, 1.7), MathUtil.degrees_to_radians(-90)),
    KeyFrameData.new(Vector2(-6.1, 1.7), MathUtil.degrees_to_radians(-90)),
  ]),
  "up": KeyFrameDataList.new([
    KeyFrameData.new(Vector2(4.1, -1.7), MathUtil.degrees_to_radians(90)),
    KeyFrameData.new(Vector2(-0.5, -4.6), MathUtil.degrees_to_radians(45)),
    KeyFrameData.new(Vector2(-5.1, -7.5), MathUtil.degrees_to_radians(0)),
    KeyFrameData.new(Vector2(-5.1, -7.5), MathUtil.degrees_to_radians(0)),
    KeyFrameData.new(Vector2(-5.1, -7.5), MathUtil.degrees_to_radians(0)),
    KeyFrameData.new(Vector2(-5.1, -7.5), MathUtil.degrees_to_radians(0)),
    KeyFrameData.new(Vector2(-5.1, -7.5), MathUtil.degrees_to_radians(0)),
    KeyFrameData.new(Vector2(-5.1, -7.5), MathUtil.degrees_to_radians(0)),
  ]),
  "upright": KeyFrameDataList.new([
    KeyFrameData.new(Vector2(4.1, -1.7), MathUtil.degrees_to_radians(90)),
    KeyFrameData.new(Vector2(-0.5, -4.6), MathUtil.degrees_to_radians(45)),
    KeyFrameData.new(Vector2(-5.1, -7.5), MathUtil.degrees_to_radians(0)),
    KeyFrameData.new(Vector2(-5.1, -7.5), MathUtil.degrees_to_radians(0)),
    KeyFrameData.new(Vector2(-5.1, -7.5), MathUtil.degrees_to_radians(0)),
    KeyFrameData.new(Vector2(-5.1, -7.5), MathUtil.degrees_to_radians(0)),
    KeyFrameData.new(Vector2(-5.1, -7.5), MathUtil.degrees_to_radians(0)),
    KeyFrameData.new(Vector2(-5.1, -7.5), MathUtil.degrees_to_radians(0)),
  ]),
  "right": KeyFrameDataList.new([
    KeyFrameData.new(Vector2(2, 5.5), MathUtil.degrees_to_radians(180)),
    KeyFrameData.new(Vector2(5.05, 2.4), MathUtil.degrees_to_radians(135)),
    KeyFrameData.new(Vector2(7.1, 0.8), MathUtil.degrees_to_radians(90)),
    KeyFrameData.new(Vector2(7.1, 0.8), MathUtil.degrees_to_radians(90)),
    KeyFrameData.new(Vector2(7.1, 0.8), MathUtil.degrees_to_radians(90)),
    KeyFrameData.new(Vector2(7.1, 0.8), MathUtil.degrees_to_radians(90)),
    KeyFrameData.new(Vector2(7.1, 0.8), MathUtil.degrees_to_radians(90)),
    KeyFrameData.new(Vector2(7.1, 0.8), MathUtil.degrees_to_radians(90)),
  ]),
  "downright": KeyFrameDataList.new([
    KeyFrameData.new(Vector2(2, 5.5), MathUtil.degrees_to_radians(180)),
    KeyFrameData.new(Vector2(5.05, 2.4), MathUtil.degrees_to_radians(135)),
    KeyFrameData.new(Vector2(7.1, 0.8), MathUtil.degrees_to_radians(90)),
    KeyFrameData.new(Vector2(7.1, 0.8), MathUtil.degrees_to_radians(90)),
    KeyFrameData.new(Vector2(7.1, 0.8), MathUtil.degrees_to_radians(90)),
    KeyFrameData.new(Vector2(7.1, 0.8), MathUtil.degrees_to_radians(90)),
    KeyFrameData.new(Vector2(7.1, 0.8), MathUtil.degrees_to_radians(90)),
    KeyFrameData.new(Vector2(7.1, 0.8), MathUtil.degrees_to_radians(90)),
  ]),
}

class KeyFrameDataList:
  var key_frames: Array[KeyFrameData]

  func _init(p_key_frames: Array[KeyFrameData] = []) -> void:
    self.key_frames = p_key_frames

  func add_key_frame(key_frame: KeyFrameData) -> void:
    self.key_frames.append(key_frame)
  

class KeyFrameData:
  var position: Vector2
  var rotation: float

  func _init(p_position: Vector2, p_rotation: float) -> void:
    self.position = p_position
    self.rotation = p_rotation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  self.initialize()

func create_animation(key_frames: KeyFrameDataList, duration: float = 0.6) -> Animation:
  var anim = Animation.new()
  anim.length = duration
  anim.loop = true

  var position_track_id: int = anim.add_track(Animation.TYPE_VALUE)
  var rotation_track_id: int = anim.add_track(Animation.TYPE_VALUE)
  var visible_track_id: int = anim.add_track(Animation.TYPE_VALUE)
  anim.track_set_path(position_track_id, weapon_position_path)
  anim.track_set_path(rotation_track_id, weapon_rotation_path)
  anim.track_set_path(visible_track_id, weapon_visible_path)
  # anim.value_track_set_update_mode(position_track_id, Animation.UPDATE_DISCRETE)
  # anim.value_track_set_update_mode(rotation_track_id, Animation.UPDATE_DISCRETE)
  anim.value_track_set_update_mode(visible_track_id, Animation.UPDATE_DISCRETE)

  for i in range(key_frames.key_frames.size()):
    var key_frame: KeyFrameData = key_frames.key_frames[i]
    var time: float = (i / float(key_frames.key_frames.size())) * duration
    anim.track_insert_key(position_track_id, time, key_frame.position)
    anim.track_insert_key(rotation_track_id, time, key_frame.rotation)

  # Insert visible at start, and hide at end.
  anim.track_insert_key(visible_track_id, 0, true)
  anim.track_insert_key(visible_track_id, duration - 0.1, false)

  return anim

func initialize() -> void:
  var animation_library: AnimationLibrary = AnimationLibrary.new()
  for direction in Directions.DIRECTION_NAMES:
    var anim_name: String = "slash_%s" % direction

    var anim: Animation = self.create_animation(POSITIONS[direction], PlayerAnimator.ANIMATION_DURATION["attack"])
    animation_library.add_animation(anim_name, anim)

  self.add_animation_library("WeaponAnimations", animation_library)
