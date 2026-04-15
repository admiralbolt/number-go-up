class_name BleedEffect extends Effect

const BLEED_ICON: Texture2D = preload("res://assets/effects/icons/bleed.png")

@export var damage_per_second: float = 0.0

func _init() -> void:
  self.effect_type = EffectType.DAMAGE
  self.is_instant = false
  self.is_stackable = true
  self.is_decaying = false
  self.refresh_duration_on_stack = false
  self.icon = BLEED_ICON

func process(target: Entity, delta: float) -> bool:
  super.process(target, delta)

  var event: Damage.DamageEvent = Damage.DamageEvent.new(target, self.damage_per_second * self.stack_count * delta, Damage.DamageType.BLEED)
  event.owner = EntityManager.get_entity(self.owner_entity_id)
  Damage.apply_damage(event)

  return self.timer <= 0

