"""A class representing a single effect that can be applied to an entity.

I would like to have this be a base class that other effect types extend from.
Resources don't save nicely when they extend a parent class though.

"""
class_name Effect extends Resource

enum EffectType {
  BUFF,
  DEBUFF,
  DAMAGE,
  HEAL
}
@export var effect_type: Effect.EffectType = Effect.EffectType.DAMAGE
@export var is_instant: bool = false
@export var duration: float = 0.0
@export var timer: float = duration

# The icon to display for this effect. We only render it if the icon is set.
# Icon should be passed in as a texture, the thing creating the effect should
# be responsible for loading/owning the resource.
@export var icon: Texture2D = null

func apply(_target: Entity) -> void:
  return

func remove(_target: Entity) -> void:
  return

func get_unique_name() -> String:
  return ""

func merge(_target:Entity, _other: Effect) -> void:
  return

func process(_target: Entity, delta: float) -> bool:
  """Processes the effect.

  Once the effect is done, return true to indiciate it should be removed.
  """
  self.timer -= delta
  if self.timer <= 0:
    return true

  return false

func _to_string() -> String:
  return "Effect(type=%s, is_instant=%s, duration=%f, timer=%f)" % [effect_type, is_instant, duration, timer]