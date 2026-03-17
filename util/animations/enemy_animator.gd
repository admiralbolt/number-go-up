class_name EnemyAnimator

class FrameList:
  var frame_indices: Array[int]

  func _init(p_frames: Array[int] = []) -> void:
    self.frame_indices = p_frames


static func frame_change_animation(sprite_path: NodePath, entry: AnimationEntry) -> Animation:
  """Creates a basic animation that changes the frame of a sprite."""
  var anim = Animation.new()
  anim.length = entry.duration
  anim.loop_mode = entry.loop_mode

  var sprite_frame_path: NodePath = "%s:frame" % sprite_path
  var texture_path: NodePath = "%s:texture" % sprite_path
  var h_frame_path: NodePath = "%s:hframes" % sprite_path
  var v_frame_path: NodePath = "%s:vframes" % sprite_path

  var frame_track_id: int = anim.add_track(Animation.TYPE_VALUE)
  var texture_track_id: int = anim.add_track(Animation.TYPE_VALUE)
  var h_frame_track_id: int = anim.add_track(Animation.TYPE_VALUE)
  var v_frame_track_id: int = anim.add_track(Animation.TYPE_VALUE)
  anim.track_set_path(frame_track_id, sprite_frame_path)
  anim.track_set_path(texture_track_id, texture_path)
  anim.track_set_path(h_frame_track_id, h_frame_path)
  anim.track_set_path(v_frame_track_id, v_frame_path)
  anim.value_track_set_update_mode(frame_track_id, Animation.UPDATE_DISCRETE)
  anim.value_track_set_update_mode(texture_track_id, Animation.UPDATE_DISCRETE)
  anim.value_track_set_update_mode(h_frame_track_id, Animation.UPDATE_DISCRETE)
  anim.value_track_set_update_mode(v_frame_track_id, Animation.UPDATE_DISCRETE)

  # Set the texture and number of h/v frames at the start.
  anim.track_insert_key(texture_track_id, 0, entry.texture)
  anim.track_insert_key(h_frame_track_id, 0, entry.texture_h_frames)
  anim.track_insert_key(v_frame_track_id, 0, entry.texture_v_frames)

  for i in range(entry.frame_indices.size()):
    var time: float = (i / float(entry.frame_indices.size())) * entry.duration
    anim.track_insert_key(frame_track_id, time, entry.frame_indices[i])

  print("creating animation name: %s, with frames: %s, hframes: %s, vframes: %s" % [entry.name, entry.frame_indices, entry.texture_h_frames, entry.texture_v_frames])

  return anim


static func create_animations(animation_player: AnimationPlayer, sprite_path: NodePath, animation_entries: Array[AnimationEntry]) -> void:
  var animation_library: AnimationLibrary = AnimationLibrary.new()
  for entry in animation_entries:
    var anim: Animation = frame_change_animation(sprite_path, entry)
    animation_library.add_animation(entry.name, anim)

  animation_player.add_animation_library("EnemyAnimations", animation_library)

static func add_animation_entries(animation_entries: Array[AnimationEntry], base_name: String, texture_path: String, frames_per_animation: int, direction_order: Array[String], vframes: int = 4, duration: float = 1.0, loop_mode: Animation.LoopMode = Animation.LoopMode.LOOP_NONE) -> void:
  var i: int = 0
  for direction_name in direction_order:
    var anim_name: String = "%s_%s" % [base_name, direction_name]
    var frame_indices: Array[int] = GodotUtil.range(i, i + frames_per_animation)
    animation_entries.append(AnimationEntry.new(anim_name, load(texture_path), frames_per_animation, vframes, frame_indices, duration, loop_mode))
    i += frames_per_animation