class_name PhysicsUtil

# When we are doing speed calculations, we want to apply friction based on the
# total speed the entity is moving and include some extra flat deceleration to
# stop things faster. Should look like this:
#
# velocity = velocity.move_toward(Vector2.ZERO, (velocity.length() * derived_statistics.friction.total_value + DECELERATION_FRICTION_CONSTANT) * delta)
const DECELERATION_FRICTION_CONSTANT: float = 55.0
const DECELERATION_MULT: float = 1.9

static func apply_deceleration(velocity: Vector2, friction: float, delta: float) -> Vector2:
  return velocity.move_toward(Vector2.ZERO, (velocity.length() * friction + DECELERATION_FRICTION_CONSTANT) * delta * DECELERATION_MULT)

# Similarly, we want to accelerate based on our total speed and some constant.
# Like so:
#
# velocity = velocity.move_toward(target_vector, (ACCELERATION_CONSTANT + max_speed) * delta * ACCELERATION_MULT)
const ACCELERATION_CONSTANT: float = 50.0
const ACCELERATION_MULT: float = 20.0

static func apply_acceleration(velocity: Vector2, target_vector: Vector2, max_speed: float, delta: float) -> Vector2:
  return velocity.move_toward(target_vector, (ACCELERATION_CONSTANT + max_speed) * delta * ACCELERATION_MULT)