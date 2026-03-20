extends Node

var tilemap_bounds: Array[Vector2]
var target_transition: String
var position_offset: Vector2

func _ready() -> void:
  await get_tree().process_frame
  SignalBus.level_loaded.emit()

func update_tilemap_bounds(bounds: Array[Vector2]) -> void:
  tilemap_bounds = bounds
  SignalBus.tilemap_bounds_changed.emit(bounds)