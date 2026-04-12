class_name MultiBuffEffect extends Effect

@export var modifiers: ModifierList

func _init() -> void:
  self.effect_type = EffectType.BUFF
  self.is_instant = false

func apply(target: Entity) -> void:
  target.modifier_manager.add_modifiers(self.modifiers.modifiers)
  # Because of stacking business, get the modifiers from the manager.
  var modifiers_from_manager: Array = self.modifiers.modifiers.map(func(m: Modifier) -> Modifier: return target.modifier_manager.get_modifier(m))
  self.duration = modifiers_from_manager.map(func(m) -> float: return m.get_total_time_left()).max()
  self.timer = self.duration

func merge(target: Entity, other: Effect) -> void:
  if other is not MultiBuffEffect:
    return

  # Because of stacking business, pull the modifiers from the manager.
  var modifiers_from_manager: Array = self.modifiers.modifiers.map(func(m: Modifier) -> Modifier: return target.modifier_manager.get_modifier(m))
  var new_list: ModifierList =  ModifierList.new()
  for modifier in modifiers_from_manager:
    new_list.modifiers.append(modifier)
  self.modifiers = new_list

  # Reset the duration and timer of the entire effect.
  self.duration = modifiers_from_manager.map(func(m) -> float: return m.get_total_time_left()).max()
  self.timer = self.duration
  self.changed.emit()

func remove(target: Entity) -> void:
  for modifier in self.modifiers.modifiers:
    target.modifier_manager.remove_modifier(modifier)

func process(target: Entity, delta: float) -> bool:
  for modifier in self.modifiers.modifiers:
    target.modifier_manager.update_modifier(modifier, delta)

  self.timer -= delta
  self.changed.emit()
  return self.timer <= 0

func get_unique_name() -> String:
  var modifier_names: String = "_".join(self.modifiers.modifiers.map(func(m: Modifier) -> String: return m.unique_name))
  return "MultiBuffEffect_%s" % modifier_names

func _to_string() -> String:
  return "Effect(type=%s, is_instant=%s, duration=%f, timer=%f)\n%s" % [effect_type, is_instant, duration, timer, modifiers]
