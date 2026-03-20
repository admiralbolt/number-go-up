class_name Level extends Node2D

func _ready() -> void:
  self.y_sort_enabled = true
  PlayerManager.set_as_parent(self)

  # We want to calculate the maximum bounds of all of the children bounded
  # tilemap levels we have.
  var min_bound: Vector2 = Vector2.INF
  var max_bound: Vector2 = Vector2.ZERO

  for child in get_children():
    if child is not TileMapLayer:
      continue

    var used_rect: Rect2 = child.get_used_rect()
    var child_min_bound: Vector2 = used_rect.position * child.rendering_quadrant_size
    var child_max_bound: Vector2 = used_rect.end * child.rendering_quadrant_size

    min_bound.x = min(min_bound.x, child_min_bound.x)
    min_bound.y = min(min_bound.y, child_min_bound.y)
    max_bound.x = max(max_bound.x, child_max_bound.x)
    max_bound.y = max(max_bound.y, child_max_bound.y)

  LevelManager.update_tilemap_bounds([min_bound, max_bound])