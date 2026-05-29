class_name MathUtil

static func degrees_to_radians(degrees: float) -> float:
  return degrees * PI / 180

static func linear_rescale(value: float, old_min: float, old_max: float, new_min: float, new_max: float) -> float:
  return new_min + (new_max - new_min) * (value - old_min) / (old_max - old_min)

# We generated a weighted random number with the following logic:
#   1. We calculate an exponent that gets closer to 0 as total_luck increases.
#   2. We randomly generate an x value between [0, 1], and get the y value.
#   3. We linearly rescale our value to that of the input min / max.
static func random_weighted(min_val: float, max_val: float, total_luck: float) -> float:
  # The magic number here is every 150 luck, our exponent decreases to the next
  # fraction down.
  var exponent: float = 150.0 / total_luck
  var curve_value: float = randf() ** exponent
  return linear_rescale(curve_value, 0, 1, min_val, max_val)

