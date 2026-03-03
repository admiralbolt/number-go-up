extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var character_statistics = CharacterStatistics.new()
  var skills = Skills.new()
  var modifiers = Modifiers.new()

  character_statistics.recompute_total_values(modifiers)
  skills.recompute_total_values(character_statistics, modifiers)

  character_statistics.debug_print()
  skills.debug_print()

  # Now lets add some modifiers.
  modifiers.add_modifier(Modifiers.Modifier.new("Flame Blade", "Spell", 30.0, [
    Modifiers.SubModifier.new(Modifiers.SubModifier.TargetType.Stat, "strength", 5.0),
    Modifiers.SubModifier.new(Modifiers.SubModifier.TargetType.Stat, "agility", 10.3),
    Modifiers.SubModifier.new(Modifiers.SubModifier.TargetType.Stat, "max_health", -15.2),
    Modifiers.SubModifier.new(Modifiers.SubModifier.TargetType.Skill, "swords", 7.3),
  ]))

  modifiers.add_modifier(Modifiers.Modifier.new("Bull Strength", "Potion", 60.0, [
    Modifiers.SubModifier.new(Modifiers.SubModifier.TargetType.Stat, "strength", 1.2, Modifiers.SubModifier.ModifierType.Multiplicative),
  ]))

  character_statistics.recompute_total_values(modifiers)
  skills.recompute_total_values(character_statistics, modifiers)

  character_statistics.debug_print()
  skills.debug_print()

  modifiers.remove_modifier("Flame Blade")

  character_statistics.recompute_total_values(modifiers)
  skills.recompute_total_values(character_statistics, modifiers)

  character_statistics.debug_print()
  skills.debug_print()
