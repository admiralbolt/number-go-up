class_name InstantHealEffect extends Effect

func _init() -> void:
  self.effect_type = EffectType.HEAL
  self.is_instant = true

func apply(target: Entity) -> void:
  print("Healing %s instantly" % target.name)
  return