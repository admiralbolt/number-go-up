class_name InstantDamageEffect extends Effect

@export var damage_amount: float = 0.0

func _init() -> void:
  self.effect_type = EffectType.DAMAGE
  self.is_instant = true

func apply(target: Entity) -> void:
  print("Dealing %.2f instant damage to %s" % [damage_amount, target.name])
  return
