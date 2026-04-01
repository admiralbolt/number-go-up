class_name Entity extends CharacterBody2D

signal damaged(hit_box: HitBox)
signal died(hit_box: HitBox)

@export var attributes: Attributes = Attributes.new()
@export var derived_statistics: DerivedStatistics = DerivedStatistics.new()
@export var skills: Skills = Skills.new()

var modifier_manager: ModifierManager = ModifierManager.new()
var effect_manager: EffectManager = EffectManager.new()

# All entities should have a hurt box.
var hurt_box: HurtBox

# Typically only enemies will have a hit box set.
var hit_box: HitBox

# Current values for bar resources + signals for them.
signal current_health_changed(new_current_health: float)
signal current_mana_changed(new_mana: float)
signal current_stamina_changed(new_stamina: float)

var current_health: float = 100.0: set = _set_current_health
var current_mana: float = 100.0: set = _set_current_mana
var current_stamina: float = 100.0: set = _set_current_stamina

func _init() -> void:
  self.initialize_stats()

  # Finally set the values based on the maxes.
  self.current_health = self.derived_statistics.max_health.total_value
  self.current_mana = self.derived_statistics.max_mana.total_value
  self.current_stamina = self.derived_statistics.max_stamina.total_value

func initialize_stats() -> void:
  self.attributes.initialize(self)
  self.derived_statistics.initialize(self)
  self.skills.initialize(self)
  self.effect_manager.initialize(self)

func _ready() -> void:
  self.modifier_manager.recomputes.connect(self._recompute_properties)

  # We need to hook into changes to the max hp/mp/sp.
  self.derived_statistics.max_health.changed.connect(self._on_max_health_changed.bind(self.derived_statistics.max_health.total_value))
  self.derived_statistics.max_mana.changed.connect(self._on_max_mana_changed.bind(self.derived_statistics.max_mana.total_value))
  self.derived_statistics.max_stamina.changed.connect(self._on_max_stamina_changed.bind(self.derived_statistics.max_stamina.total_value))

func take_damage(p_hit_box: HitBox) -> void:
  # Eventually we'll do some math here based on stats n' stuff.
  var damage: float = 10
  if p_hit_box.owner is Entity:
    damage += p_hit_box.owner.attributes.strength.total_value * 0.6
  # print("Entity: %s, is taking: %f damage" % [self.name, damage])
  self.current_health -= damage
  # print("Entity has %f current_health and %f max_health" % [self.current_health, self.derived_statistics.max_health.total_value])
  damaged.emit(p_hit_box)

  if self.current_health <= 0:
    died.emit(p_hit_box)

func _set_current_health(p_health: float) -> void:
  if p_health == current_health:
    return

  current_health = clamp(p_health, 0, self.derived_statistics.max_health.total_value)
  current_health_changed.emit(p_health)

func _set_current_mana(p_mana: float) -> void:
  if p_mana == current_mana:
    return

  current_mana = clamp(p_mana, 0, self.derived_statistics.max_mana.total_value)
  current_mana_changed.emit(p_mana)

func _set_current_stamina(p_stamina: float) -> void:
  if p_stamina == current_stamina:
    return

  current_stamina = clamp(p_stamina, 0, self.derived_statistics.max_stamina.total_value)
  current_stamina_changed.emit(p_stamina)

# The logic for these three functions is the same.
func _on_max_health_changed(_p_max_health: float) -> void:
  if self.current_health >= self.derived_statistics.max_health.total_value:
    self.current_health = self.derived_statistics.max_health.total_value
    return

func _on_max_mana_changed(_p_max_mana: float) -> void:
  if self.current_mana >= self.derived_statistics.max_mana.total_value:
    self.current_mana = self.derived_statistics.max_mana.total_value
    return

func _on_max_stamina_changed(_p_max_stamina: float) -> void:
  if self.current_stamina >= self.derived_statistics.max_stamina.total_value:
    self.current_stamina = self.derived_statistics.max_stamina.total_value
    return

func _process(delta: float) -> void:
  self.effect_manager.process(delta)

  # Update regeneration of health, mana, and stamina.
  self.current_health += self.derived_statistics.health_regen.total_value * delta
  self.current_mana += self.derived_statistics.mana_regen.total_value * delta
  self.current_stamina += self.derived_statistics.stamina_regen.total_value * delta

func _recompute_properties(recompute_targets: Dictionary[Modifier.ModifierTarget, ModifierManager.RecomputeTargetList]) -> void:
  for target_type in [Modifier.ModifierTarget.ATTRIBUTE, Modifier.ModifierTarget.DERIVED_STATISTIC, Modifier.ModifierTarget.SKILL]:
    var target_list: ModifierManager.RecomputeTargetList = recompute_targets.get(target_type)
    if target_list == null:
      continue

    for target in target_list.targets:
      match target.target_type:
        Modifier.ModifierTarget.ATTRIBUTE:
          var attr: Attribute = self.attributes.get(target.stat_name)
          if attr != null:
            attr.compute_total()

        Modifier.ModifierTarget.DERIVED_STATISTIC:
          var stat: DerivedStatistic = self.derived_statistics.get(target.stat_name)
          if stat != null:
            stat.compute_total()

        Modifier.ModifierTarget.SKILL:
          var skill: Skill = self.skills.get(target.stat_name)
          if skill != null:
            skill.compute_total()

func debug_print() -> void:
  self.attributes.debug_print()
  self.derived_statistics.debug_print()
  self.skills.debug_print()
