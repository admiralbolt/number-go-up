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

static func range(start: int, end: int) -> Array[int]:
  """Returns an array of integers from start to end (exclusive).

  The fact that I have to write this function is completely asinine.
  """
  var result: Array[int] = []
  for i in range(start, end):
    result.append(i)
  return result

static func wait_process_frames(scene_tree: SceneTree, frames: int = 1) -> void:
  """Wait for a given number of process frames."""
  for _i in range(frames):
    await scene_tree.process_frame
  return

static func format_timestamp(timestamp: float) -> String:
  var date_time: Dictionary = Time.get_datetime_dict_from_unix_time(int(timestamp))

  return "%s-%s-%s %s:%s:%s" % [date_time["year"], date_time["month"], date_time["day"], date_time["hour"], date_time["minute"], date_time["second"]]

static func format_elapsed_time(total_seconds: float) -> String:
  var accumulator: Array[float] = [total_seconds]
  var int_value: Array[int] = [int(total_seconds) % 60]
  for divisor in [60, 60, 24]:
    var val: float = accumulator[-1] / divisor
    accumulator.append(val)
    int_value.append(int(val) % divisor)

  if accumulator[3] > 1:
    return "%dD %dH %dM %dS" % [int_value[3], int_value[2], int_value[1], int_value[0]]

  if accumulator[2] > 1:
    return "%dD %dH %dM %dS" % [int_value[2], int_value[1], int_value[0]]

  return "%dM %dS" % [int_value[1], int_value[0]]
