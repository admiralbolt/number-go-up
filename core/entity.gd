class_name Entity extends CharacterBody2D

@export var attributes: Attributes = Attributes.new()
@export var derived_statistics: DerivedStatistics = DerivedStatistics.new()
@export var skills: Skills = Skills.new()
var modifier_manager: ModifierManager = ModifierManager.new()

func _init() -> void:
  self.attributes.initialize(self)
  self.derived_statistics.initialize(self)
  self.skills.initialize(self)

  self.modifier_manager.recomputes.connect(self._recompute_properties)

func _recompute_properties(recompute_targets: Dictionary[Modifier.ModifierTarget, ModifierManager.RecomputeTargetList]) -> void:
  for target_type in recompute_targets.keys():
    var target_list: ModifierManager.RecomputeTargetList = recompute_targets[target_type]
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



