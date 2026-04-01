class_name BuffEffect extends Effect

@export var modifier: Modifier: set = _set_modifier

func _init() -> void:
  self.effect_type = EffectType.BUFF
  self.is_instant = false

func _set_modifier(p_modifier: Modifier) -> void:
  modifier = p_modifier
  duration = modifier.duration
  timer = modifier.timer + 20

  # var p_effect_base: EffectBase = EffectBase.new()
  # p_effect_base.effect_type = EffectType.BUFF
  # p_effect_base.is_instant = false
  # p_effect_base.duration = duration
  # p_effect_base.timer = timer
  # effect_base = p_effect_base

func apply(target: Entity) -> void:
  target.modifier_manager.add_modifier(modifier)

func remove(target: Entity) -> void:
  target.modifier_manager.remove_modifier(modifier)

func process(target: Entity, delta: float) -> bool:
  target.modifier_manager.update_modifier(modifier, delta)
  self.timer -= delta

  return modifier.timer <= 0

func _to_string() -> String:
  return "Effect(type=%s, is_instant=%s, duration=%f, timer=%f)\n%s" % [effect_type, is_instant, duration, timer, modifier]