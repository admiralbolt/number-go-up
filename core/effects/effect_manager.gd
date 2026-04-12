class_name EffectManager extends Resource

signal effect_added(effect: Effect)
signal effect_removed(effect: Effect)

var entity: Entity
var active_effects: Array[Effect] = []

func initialize(p_entity: Entity) -> void:
  self.entity = p_entity

func process(delta: float) -> void:
  var removal_indices: Array[int] = []

  for i in active_effects.size():
    if not active_effects[i].process(self.entity, delta):
      continue

    # The effect is over!
    removal_indices.append(i)
  
  for i in removal_indices.size():
    # Make sure we shift the index back since we're deleting as we go.
    var index: int = removal_indices[i] - i
    self.effect_removed.emit(active_effects[index])
    active_effects[index].remove(self.entity)
    active_effects.remove_at(removal_indices[i] - i)

func clear() -> void:
  for effect in self.active_effects:
    effect.remove(self.entity)

  self.active_effects.clear()

func reinitialize(p_effects: Array[Effect]) -> void:
  self.clear()
  for effect in p_effects:
    self.apply_effect(effect)

func apply_effect(effect: Effect) -> void:
  effect.apply(self.entity)
  if effect.is_instant:
    return

  var existing_effect: Effect = self.get_effect(effect)
  if existing_effect == null:
    effect.timer = effect.duration
    active_effects.append(effect)
    self.effect_added.emit(effect)
    return

  existing_effect.merge(self.entity, effect)

func get_effect(effect: Effect) -> Effect:
  for active_effect in active_effects:
    if active_effect.get_unique_name() == effect.get_unique_name():
      return active_effect

  return null