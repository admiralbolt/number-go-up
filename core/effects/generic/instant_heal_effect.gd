class_name InstantHealEffect extends Effect

var heal_amount: float = 0.0

static func make(p_heal_amount: float) -> InstantHealEffect:
  var effect: InstantHealEffect = InstantHealEffect.new()
  effect.effect_type = EffectType.HEAL
  effect.is_instant = true
  effect.heal_amount = p_heal_amount
  return effect

func apply(target: Entity) -> void:
  target.current_health += self.heal_amount