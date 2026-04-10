
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
@export var modifier_type: ModifierType = ModifierType.ADDITIVE
@export var modifier_priority: ModifierPriority = ModifierPriority.APPLY_ADDITIVE
@export var sentiment: ModifierSentiment = ModifierSentiment.NEUTRAL

@export var duration: float = -1: set = _set_duration
@export var timer: float = 0
@export var is_decaying: bool = false
@export var is_timed: bool = false
@export var is_stackable: bool = false
@export var refresh_on_stack: bool = false
@export var stack_count: int = 1
@export var stack_fall_off: int = 1

var unique_name: String = "": get = _get_unique_name

func _set_duration(p_duration: float) -> void:
  duration = p_duration
  is_timed = duration > 0
  timer = duration

func _get_unique_name() -> String:
  if unique_name == "":
     unique_name = "%s_%s_%s" % [self.source_name, ModifierSource.keys()[self.source_type], self.stat_name]
  return unique_name

func eq(other: Modifier) -> bool:
  return self.unique_name == other.unique_name

func can_stack(other: Modifier) -> bool:
  return self.is_stackable and other.is_stackable and self.eq(other)

func get_total_value() -> float:
  if self.is_stackable:
    return self.value * self.stack_count

  if self.is_decaying:
    return self.value * (self.timer / self.duration)

  return self.value

func apply(base_value: float) -> float:
  match self.modifier_type:
    ModifierType.ADDITIVE:
      return base_value + self.get_total_value()
    ModifierType.MULTIPLICATIVE:
      return base_value * (1 + self.get_total_value())

  print("Unknown modifier type: %s" % self.modifier_type)
  return base_value

func get_total_time_left() -> float:
  if not self.is_stackable:
    return self.timer

  return self.timer + (self.stack_count - 1) * self.duration

func _to_string() -> String:
  return "Modifier(%s) %s, %s, %s, value: %.2f, type: %s, priority: %s, sentiment: %s, duration: %s, timer: %s, is_timed: %s, is_stackable: %s, stack_count: %s, stack_fall_off: %s" % [self.unique_name, self.source_name, ModifierSource.keys()[self.source_type], self.stat_name, self.value, ModifierType.keys()[self.modifier_type], ModifierPriority.keys()[self.modifier_priority], ModifierSentiment.keys()[self.sentiment], self.duration, self.timer, self.is_timed, self.is_stackable, self.stack_count, self.stack_fall_off]

func _get_mod_char() -> String:
  if self.modifier_type == ModifierType.ADDITIVE:
    return "+" if self.value >= 0 else "-"
  elif self.modifier_type == ModifierType.MULTIPLICATIVE:
    return "x" if self.value >= 0 else "/"
  
  return "?"

func readable_string() -> String:
  return "%s (%s%s)" % [self.source_name, self._get_mod_char(), self.get_total_value() + (1 if self.modifier_type == ModifierType.MULTIPLICATIVE else 0)]