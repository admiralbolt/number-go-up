class_name Entity extends CharacterBody2D

signal initialized()

var attributes: Attributes
var derived_statistics: DerivedStatistics
var skills: Skills

var modifier_manager: ModifierManager = ModifierManager.new()
var effect_manager: EffectManager = EffectManager.new()

# Current values for bar resources + signals for them.
signal current_health_changed(new_current_health: float)
signal current_mana_changed(new_mana: float)
signal current_stamina_changed(new_stamina: float)

var current_health: float = 100.0: set = _set_current_health
var current_mana: float = 100.0
var current_stamina: float = 100.0

func initialize(p_attributes: Attributes, p_derived_statistics: DerivedStatistics, p_skills: Skills) -> void:
  self.attributes = p_attributes
  self.derived_statistics = p_derived_statistics
  self.skills = p_skills

  self.attributes.initialize(self)
  self.derived_statistics.initialize(self)
  self.skills.initialize(self)
  self.effect_manager.initialize(self)

  self.modifier_manager.recomputes.connect(self._recompute_properties)

  # We need to hook into changes to the max hp/mp/sp.
  self.derived_statistics.max_health.connect("changed", self._on_max_health_changed)
  self.derived_statistics.max_mana.connect("changed", self._on_max_mana_changed)
  self.derived_statistics.max_stamina.connect("changed", self._on_max_stamina_changed)

  # Finally set the values based on the maxes.
  self.current_health = self.derived_statistics.max_health.total_value

  self.initialized.emit()

func take_damage(hit_box: HitBox) -> void:
  # Eventually we'll do some math here based on stats n' stuff.
  var damage: float = 10
  if hit_box.owner is Entity:
    damage += hit_box.owner.attributes.strength.total_value * 0.6
  print("Entity: %s, is taking: %f damage" % [self.name, damage])
  self.current_health -= damage
  print("Entity has %f current_health and %f max_health" % [self.current_health, self.derived_statistics.max_health.total_value])

func _set_current_health(p_health: float) -> void:
  if p_health == current_health:
    return

  current_health = p_health
  current_health_changed.emit(p_health)

# The logic for these three functions is the same.
func _on_max_health_changed() -> void:
  if self.current_health >= self.derived_statistics.max_health.total_value:
    self.current_health = self.derived_statistics.max_health.total_value
    return

func _on_max_mana_changed() -> void:
  if self.current_mana >= self.derived_statistics.max_mana.total_value:
    self.current_mana = self.derived_statistics.max_mana.total_value
    return

func _on_max_stamina_changed() -> void:
  if self.current_stamina >= self.derived_statistics.max_stamina.total_value:
    self.current_stamina = self.derived_statistics.max_stamina.total_value
    return

func _process(delta: float) -> void:
  self.effect_manager.process(delta)

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



