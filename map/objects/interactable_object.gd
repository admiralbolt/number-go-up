class_name InteractableObject extends Entity

@export var is_breakable: bool = false

func _ready() -> void:
  self.gives_skill_xp = false
  self._setup_stats()

  super._ready()
  self.current_health = self.derived_statistics.max_health.total_value

func _setup_stats() -> void:
  self.xp = 0

  self.attributes.strength.value = 0
  self.attributes.constitution.value = 0
  self.attributes.dexterity.value = 0
  self.attributes.agility.value = 0
  self.attributes.spirit.value = 0
  self.attributes.wisdom.value = 0
  self.attributes.intelligence.value = 0
  self.attributes.charisma.value = 0
  self.attributes.luck.value = 0

  self.derived_statistics.armor.base_value = 50
  self.derived_statistics.max_health.base_value = 100
  self.derived_statistics.health_regen.base_value = 0
  self.derived_statistics.movement_speed.base_value = 0
  self.derived_statistics.knockback_resistance.base_value = 0.98

  self.effect_immunities[BleedEffect.NAME] = true