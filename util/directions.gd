class_name Directions

static var DIRECTION_NAMES = ["down", "downright", "right", "upright", "up", "upleft", "left", "downleft"]

static func get_direction_name(direction: Vector2) -> String:
  if direction == Vector2.ZERO:
    return "down"

  var angle: float = direction.angle()
  # We need to adjust our angle so that the default is down, and goes counter clockwise.
  # We just need to subtract PI/2 from our angle.
  var octant: int = int(round((angle + 3 * PI / 2) / (PI / 4))) % 8
  return ["down", "downleft", "left", "upleft", "up", "upright", "right", "downright"][octant]