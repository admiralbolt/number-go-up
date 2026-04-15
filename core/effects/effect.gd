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

# Who owns this effect. This is important for something like a status effect
# like bleed. The damage is applied by the player, so they should ultimately
# get the XP if the bleed kills the enemy.
@export var owner_entity_id: String
@export var duration: float = 0.0
@export var timer: float = duration

@export var is_decaying: bool = false
@export var is_stackable: bool = false
# If set, then when we stack we refresh the duration.
@export var refresh_duration_on_stack: bool = false
@export var stack_count: int = 1
@export var stack_fall_off: int = 1

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

func merge(_target:Entity, other: Effect) -> void:
  # If the effect is not stackable, refresh the timer and return.
  if not self.is_stackable:
    self.duration = max(self.duration, other.duration)
    self.timer = max(self.timer, other.timer)
    self.changed.emit()
    return

  self.stack_count += other.stack_count
  if self.refresh_duration_on_stack:
    self.timer = max(self.timer, other.timer)

  self.changed.emit()
  return

func process(_target: Entity, delta: float) -> bool:
  """Processes the effect.

  Once the effect is done, return true to indiciate it should be removed.
  """
  self.timer -= delta

  if self.timer <= 0:
    if self.is_stackable and self.stack_count > self.stack_fall_off:
      self.stack_count -= self.stack_fall_off
      self.timer = self.duration

  return self.timer <= 0

func _to_string() -> String:
  return "Effect(type=%s, is_instant=%s, duration=%f, timer=%f)" % [effect_type, is_instant, duration, timer]