class_name EffectManager extends Resource

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
    active_effects.remove_at(removal_indices[i] - i)

func apply_effect(effect: Effect) -> void:
  effect.apply(self.entity)
  if effect.is_instant:
    return

  effect.timer = effect.duration
  active_effects.append(effect)