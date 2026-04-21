class_name InstantHealEffect extends Effect

var heal_amount: float = 0.0

func _init(p_heal_amount: float) -> void:
  self.effect_type = EffectType.HEAL
  self.is_instant = true
  self.heal_amount = p_heal_amount

func apply(target: Entity) -> void:
  target.current_health += self.heal_amount