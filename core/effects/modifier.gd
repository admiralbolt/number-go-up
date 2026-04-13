
"""A generic class representing modifiers to things.

These things can be attributes, derived statistics, or skills. The modifiers
themselves don't actually know what they are modifying, they just use the
string name of the thing to properly compute totals.
"""
class_name Modifier extends Resource

enum ModifierSource {
  DIVINE,
  EQUIPMENT,
  SPELL,
  SKILL_NODE_PASSIVE,
  SKILL_NODE_TRIGGERED
}

enum ModifierTarget {
  ATTRIBUTE,
  DERIVED_STATISTIC,
  SKILL
}

enum ModifierType {
  ADDITIVE,
  MULTIPLICATIVE
}

# APPLY_FIRST means it is used in calculations first.
# APPLY_LAST means it is used in calculations last.
enum ModifierPriority {
  APPLY_FIRST,
  APPLY_ADDITIVE,
  APPLY_MULTIPLICATIVE,
  APPLY_LAST
}

enum ModifierSentiment {
  BUFF,
  DEBUFF,
  NEUTRAL
}

@export var source_name: String = ""
@export var source_type: ModifierSource = ModifierSource.DIVINE
@export var target_type: ModifierTarget = ModifierTarget.ATTRIBUTE
@export var stat_name: String = ""
@export var value: float = 1.0
@export var base_value: float = 1.0
@export var modifier_type: ModifierType = ModifierType.ADDITIVE
@export var modifier_priority: ModifierPriority = ModifierPriority.APPLY_ADDITIVE
@export var sentiment: ModifierSentiment = ModifierSentiment.NEUTRAL

var unique_name: String = "": get = _get_unique_name

func _get_unique_name() -> String:
  if unique_name == "":
     unique_name = "%s_%s_%s" % [self.source_name, ModifierSource.keys()[self.source_type], self.stat_name]
  return unique_name

func eq(other: Modifier) -> bool:
  return self.unique_name == other.unique_name

func apply(p_base_value: float) -> float:
  match self.modifier_type:
    ModifierType.ADDITIVE:
      return p_base_value + self.value
    ModifierType.MULTIPLICATIVE:
      return p_base_value * (1 + self.value)

  print("Unknown modifier type: %s" % self.modifier_type)
  return p_base_value

func _to_string() -> String:
  return "Modifier(%s) %s, %s, %s, value: %.2f, type: %s, priority: %s, sentiment: %s" % [self.unique_name, self.source_name, ModifierSource.keys()[self.source_type], self.stat_name, self.value, ModifierType.keys()[self.modifier_type], ModifierPriority.keys()[self.modifier_priority], ModifierSentiment.keys()[self.sentiment]]

func _get_mod_char() -> String:
  if self.modifier_type == ModifierType.ADDITIVE:
    return "+" if self.value >= 0 else "-"
  elif self.modifier_type == ModifierType.MULTIPLICATIVE:
    return "x" if self.value >= 0 else "/"
  
  return "?"

func readable_string() -> String:
  return "%s (%s%s)" % [self.source_name, self._get_mod_char(), self.value + (1 if self.modifier_type == ModifierType.MULTIPLICATIVE else 0)]
