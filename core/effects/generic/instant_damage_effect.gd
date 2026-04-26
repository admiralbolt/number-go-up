class_name InstantDamageEffect extends Effect

@export var damage_amount: float = 0.0

func _init() -> void:
  self.effect_type = EffectType.DAMAGE
  self.is_instant = true

func apply(target: Entity) -> void:
  target.current_health -= damage_amount
