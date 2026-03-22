class_name Directions

static var PRIMARY_DIRECTION_NAMES: Array[String] = ["down", "right", "up", "left"]
static var DIRECTION_NAMES: Array[String] = ["down", "downright", "right", "upright", "up", "upleft", "left", "downleft"]

static func get_direction_name(direction: Vector2) -> String:
  if direction == Vector2.ZERO:
    return "down"

  var angle: float = direction.angle()
  # We need to adjust our angle so that the default is down, and goes counter clockwise.
  # We just need to subtract PI/2 from our angle.
  var octant: int = int(round((angle + 3 * PI / 2) / (PI / 4))) % 8
  return ["down", "downleft", "left", "upleft", "up", "upright", "right", "downright"][octant]

static func get_primary_direction_name(direction: Vector2) -> String:
  var direction_name: String = get_direction_name(direction)
  for primary_direction in PRIMARY_DIRECTION_NAMES:
    if direction_name.begins_with(primary_direction):
      return primary_direction

  return "down"
