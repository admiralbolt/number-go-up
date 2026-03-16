class_name WeaponAnimator extends AnimationPlayer

@onready var weapon_parent_node: Node2D = $"../SpriteAndShape"
@onready var anim_root_node: Node = self.get_node(self.root_node)
@onready var weapon_parent_node_path: NodePath = anim_root_node.get_path_to(weapon_parent_node)

@onready var weapon_visible_path: NodePath = "%s:visible" % weapon_parent_node_path
@onready var weapon_position_path: NodePath = "%s:position" % weapon_parent_node_path
@onready var weapon_rotation_path: NodePath = "%s:rotation" % weapon_parent_node_path

var weapon: Weapon

static func make_key_frame_list(point: Vector2, rotation_from: float, rotation_to: float) -> KeyFrameDataList:
  var key_frame_data_list: KeyFrameDataList = KeyFrameDataList.new()
  key_frame_data_list.add_key_frame(KeyFrameData.new(point, MathUtil.degrees_to_radians(rotation_from)))
  key_frame_data_list.add_key_frame(KeyFrameData.new(point, MathUtil.degrees_to_radians((rotation_to + rotation_from) / 2)))

  for _i in range(6):
    key_frame_data_list.add_key_frame(KeyFrameData.new(point, MathUtil.degrees_to_radians(rotation_to)))

  return key_frame_data_list


# Will eventually need to abstract this a bit, but for now let's test
# this manually / semi-randomly to see what's what.
var POSITIONS: Dictionary[String, KeyFrameDataList] = {
  "down": make_key_frame_list(Vector2(0, 8), -120, -240),
  "downleft": make_key_frame_list(Vector2(-5, 5), -75, -195),
  "left": make_key_frame_list(Vector2(-8, 0), -30, -150),
  "upleft": make_key_frame_list(Vector2(-5, -5), 15, -105),
  "up": make_key_frame_list(Vector2(0, -8), 60, -60),
  "upright": make_key_frame_list(Vector2(5, -5), 105, -15),
  "right": make_key_frame_list(Vector2(8, 0), 150, 30),
  "downright": make_key_frame_list(Vector2(5, 5), 195, 75),
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
    anim.track_insert_key(rotation_track_id, time, key_frame.rotation - MathUtil.degrees_to_radians(self.weapon.base_rotation_degrees))

  # Insert visible at start, and hide at end.
  anim.track_insert_key(visible_track_id, 0, true)
  anim.track_insert_key(visible_track_id, duration - 0.1, false)

  return anim

func initialize(p_weapon: Weapon) -> void:
  self.weapon = p_weapon
  var animation_library: AnimationLibrary = AnimationLibrary.new()
  for direction in Directions.DIRECTION_NAMES:
    var anim_name: String = "slash_%s" % direction

    print("Creating animation: %s" % anim_name)

    var anim: Animation = self.create_animation(POSITIONS[direction], PlayerAnimator.ANIMATION_DURATION["attack"])
    animation_library.add_animation(anim_name, anim)

  self.add_animation_library("WeaponAnimations", animation_library)

func reset() -> void:
  if self.has_animation_library("WeaponAnimations"):
    self.remove_animation_library("WeaponAnimations")
