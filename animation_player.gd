extends AnimationPlayer

static var DIRECTIONS = ["down", "downright", "right", "upright", "up", "upleft", "left", "downleft"]
static var ACTIONS = ["walk", "roll", "attack"]

@onready var sprite: Sprite2D = %Sprite2D
@onready var anim_root_node: Node = self.get_node(self.root_node)
@onready var sprite_path: NodePath = anim_root_node.get_path_to(sprite)
@onready var sprite_frame_path: NodePath = "%s:frame" % sprite_path


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  self.initialize_with_duration(0.6)
  pass # Replace with function body.

func create_animation(frame_indices: Array[int], duration: float = 0.6) -> Animation:
  var anim = Animation.new()
  anim.length = duration
  anim.loop = true

  var frame_track_id: int = anim.add_track(Animation.TYPE_VALUE)
  anim.track_set_path(frame_track_id, sprite_frame_path)

  for i in range(frame_indices.size()):
    var time: float = (i / float(frame_indices.size())) * duration
    anim.track_insert_key(frame_track_id, time, frame_indices[i])

  return anim

func initialize_with_duration(duration: float = 0.6) -> void:
  var frame: int = 0
  var animation_library: AnimationLibrary = AnimationLibrary.new()
  for action in ACTIONS:
    for direction in DIRECTIONS:
      var anim_name: String = "%s_%s" % [action, direction]
      var frame_indices: Array[int] = [frame, frame + 1, frame + 2, frame + 3]

      var anim: Animation = self.create_animation(frame_indices, duration)
      animation_library.add_animation(anim_name, anim)
      frame += 4

  self.add_animation_library("PlayerAnimations", animation_library)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
