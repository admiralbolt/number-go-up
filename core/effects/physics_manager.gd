"""Managing knockback effects separately!

REMEMBER: YOU MUST RESET VELOCITY ON ALL PROCESS FRAMES.
"""

class_name PhysicsManager

var owner: Entity

var knockback_effects: Array[KnockbackEffect] = []

func _init(p_owner: Entity) -> void:
  self.owner = p_owner

func apply_knockback(hit_box: HitBox, duration: float = 0.5) -> void:
  # Might want to pass in direction eventually, for now we just calc.
  var direction: Vector2 = -1 * self.owner.global_position.direction_to(hit_box.global_position)
  var knockback_strength: float = hit_box.knockback * (1 - self.owner.derived_statistics.knockback_resistance.total_value)
  var knockback_effect = KnockbackEffect.new(direction, knockback_strength, duration)
  self.knockback_effects.append(knockback_effect)

func clear() -> void:
  self.knockback_effects.clear()

func process_effects(delta: float) -> void:
  var removal_indices: Array[int] = []
  # At this point our velocity should be set by other things, update based on
  # knockback effects.
  for i in self.knockback_effects.size():
    var effect: KnockbackEffect = self.knockback_effects[i]
    # Apply the effect.
    self.owner.velocity += effect.direction * effect.strength

    effect.duration = max(effect.duration - delta, 0)
    # Knockback strength should get to 0 by the end of the duration.
    effect.strength = pow(effect.duration / effect.max_duration, 2) * effect.max_strength

    if effect.duration <= 0:
      removal_indices.append(i)

  for i in removal_indices.size():
    # Make sure we shift the index back since we're deleting as we go.
    self.knockback_effects.remove_at(removal_indices[i] - i)

class KnockbackEffect:
  var direction: Vector2
  var strength: float
  var max_strength: float
  var duration: float
  var max_duration: float

  func _init(p_direction: Vector2, p_strength: float, p_duration: float = 0.5) -> void:
    self.direction = p_direction
    self.strength = p_strength
    self.max_strength = self.strength
    self.duration = p_duration
    self.max_duration = self.duration

  func _to_string() -> String:
    return "KnockbackEffect(direction: %s, strength: (%.2f, %.2f), duration: (%.2f, %.2f))" % [self.direction, self.strength, self.max_strength, self.duration, self.max_duration]
