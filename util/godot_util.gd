class_name GodotUtil

static var PLAYER_LAYER: int = 1
static var ENEMY_LAYER: int = 2
static var WALL_LAYER: int = 5

static func queue_free_timer(node: Node, time: float) -> void:
  """Call queue_free() after the given time."""
  var new_timer = Timer.new()
  node.add_child(new_timer)
  new_timer.timeout.connect(node.queue_free)
  new_timer.call_deferred("start", time)