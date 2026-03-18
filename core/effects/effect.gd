"""A class representing a single effect that can be applied to an entity."""
@abstract class_name Effect extends Resource

enum EffectType {
  BUFF,
  DEBUFF,
  DAMAGE,
  HEAL
}

@export var effect_type: EffectType = EffectType.BUFF
@export var is_instant: bool = false
@export var duration: float = 0.0

var timer: float = duration

@abstract func apply(_target: Entity) -> void

func process(_target: Entity, delta: float) -> bool:
  """Processes the effect.

  Once the effect is done, return true to indiciate it should be removed.
  """
  self.timer -= delta
  if self.timer <= 0:
    return true

  return false