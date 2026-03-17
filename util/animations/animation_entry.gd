class_name AnimationEntry extends Resource

@export var name: String
@export var texture: Texture2D
@export var texture_h_frames: int
@export var texture_v_frames: int
@export var frame_indices: Array[int]
@export var duration: float
@export var loop_mode: Animation.LoopMode

func _init(p_name: String, p_texture: Texture2D, p_texture_h_frames: int, p_texture_v_frames: int, p_frame_indices: Array[int], p_duration: float, p_loop_mode: Animation.LoopMode = Animation.LoopMode.LOOP_NONE) -> void:
  self.name = p_name
  self.texture = p_texture
  self.texture_h_frames = p_texture_h_frames
  self.texture_v_frames = p_texture_v_frames
  self.frame_indices = p_frame_indices
  self.duration = p_duration
  self.loop_mode = p_loop_mode

func _to_string() -> String:
  return "AnimationEntry(name=%s, texture_h_frames=%d, texture_v_frames=%d, frame_indices=%s, duration=%f, loop_mode=%s)" % [name, texture_h_frames, texture_v_frames, frame_indices, duration, loop_mode]