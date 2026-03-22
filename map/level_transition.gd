@tool
class_name LevelTransition extends Area2D

const TRANSITION_PIXEL_SHIFT: float = 6

@export_file("*.tscn") var level: String
@export var target_transition_area: String = "LevelTransition"

@export_category("Collision Area Settings")
@export_range(1, 12, 1, "or_greater") var size: int = 1: set = _set_size
@export var side: Side = SIDE_LEFT: set = _set_side
@export_tool_button("Snap To Grid", "Callable") var do_the_snap = _snap_to_grid

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
  self._update_area()
  
  if Engine.is_editor_hint():
    return

  self.monitoring = false
  # Technically unnecessary, but I like adding the proper collision / mask
  # values in code.
  self.set_collision_layer_value(1, false)
  self.set_collision_mask_value(1, true)

  if self.name == LevelManager.target_transition:
    PlayerManager.player.global_position = self.global_position + LevelManager.position_offset

  await SignalBus.level_loaded
  body_entered.connect(_on_body_entered)
  self.monitoring = true 

func _set_size(p_size: int) -> void:
  size = p_size
  _update_area()

func _set_side(p_side: Side) -> void:
  side = p_side
  _update_area()

func _on_body_entered(_body: Node2D) -> void:
  var offset: Vector2 = Vector2.ZERO
  if self.side % 2 == 0:
    offset.y = PlayerManager.player.global_position.y - global_position.y
    offset.x = -1 * TRANSITION_PIXEL_SHIFT if side == SIDE_LEFT else TRANSITION_PIXEL_SHIFT
  else:
    offset.x = PlayerManager.player.global_position.x - global_position.x
    offset.y = - 1 * TRANSITION_PIXEL_SHIFT if side == SIDE_TOP else TRANSITION_PIXEL_SHIFT


  LevelManager.load_new_level(self.level, self.target_transition_area, offset)

func _update_area() -> void:
  var new_rect: Vector2 = Vector2(16, 16)
  var new_position: Vector2 = Vector2.ZERO

  new_rect *= Vector2(
    self.size if self.side % 2 == 1 else 1,
    self.size if self.side % 2 == 0 else 1
  )

  if self.side % 2 == 0:
    new_position.x += 16 if self.side == SIDE_RIGHT else -16
  else:
    new_position.y += 16 if self.side == SIDE_BOTTOM else -16

  if self.collision_shape == null:
    self.collision_shape = get_node("CollisionShape2D")

  collision_shape.shape.size = new_rect
  collision_shape.position = new_position
  

func _snap_to_grid() -> void:
  position.x = round(position.x / 8) * 8
  position.y = round(position.y / 8) * 8
