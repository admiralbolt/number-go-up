class_name BuffEffect extends Effect

@export var modifier: Modifier

func _init() -> void:
  self.effect_type = EffectType.BUFF
  self.is_instant = false

func apply(target: Entity) -> void:
  target.modifier_manager.add_modifier(modifier)

func process(target: Entity, delta: float) -> bool:
  target.modifier_manager.update_modifier(modifier, delta)

  return modifier.timer <= 0