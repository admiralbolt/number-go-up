class_name BuffEffect extends Effect

@export var modifiers: ModifierList = ModifierList.new()

func _init() -> void:
  self.effect_type = EffectType.BUFF
  self.is_instant = false

func apply(target: Entity) -> void:
  for modifier in self.modifiers.modifiers:
    target.modifier_manager.add_modifier(modifier)

func merge(target: Entity, other: Effect) -> void:
  if not other is BuffEffect:
    return

  super.merge(target, other)

  # Sometimes the base values of a modifier might change on a reapply. If we
  # rank up a kill skill that stacks, the new modifier will have a higher
  # base value. We take the highest base value available.
  #
  # Also, we are making the dangerous assumption that modifiers are in the
  # same order for both effects (which is generally true for the same effect).
  for i in range(self.modifiers.modifiers.size()):
    var own_modifier: Modifier = self.modifiers.modifiers[i]
    var other_modifier: Modifier = other.modifiers.modifiers[i]

    # Check for greater magnitude, in case of negative values.
    if abs(other_modifier.base_value) > abs(own_modifier.base_value):
      own_modifier.base_value = other_modifier.base_value
      
func remove(target: Entity) -> void:
  for modifier in self.modifiers.modifiers:
    target.modifier_manager.remove_modifier(modifier)

func process(target: Entity, delta: float) -> bool:
  super.process(target, delta)

  for modifier in self.modifiers.modifiers:
    if self.is_stackable:
      var new_val: float = modifier.base_value * self.stack_count
      if new_val != modifier.value:
        modifier.value = new_val
        SignalBus.modifier_changed.emit(modifier.stat_name)
    elif self.is_decaying:
      modifier.value = modifier.base_value * (self.timer / self.duration)
      SignalBus.modifier_changed.emit(modifier.stat_name)

  self.changed.emit()
  return self.timer <= 0

func get_unique_name() -> String:
  var modifier_names: String = "_".join(self.modifiers.modifiers.map(func(m: Modifier) -> String: return m.unique_name))
  return "BuffEffect_%s" % modifier_names

func _to_string() -> String:
  return "Effect(type=%s, is_instant=%s, duration=%f, timer=%f)\n%s" % [effect_type, is_instant, duration, timer, modifiers]
