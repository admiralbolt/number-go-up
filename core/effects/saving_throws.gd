"""Saving Throws!

The maths here is going to differentiate from the standard D&D stuff a little.
Saving throws will generate some value, and we will compare that against the
DC to determine the overall efficacy. This won't be a direct pass/fail in 
most cases, and use the same type of logarithmic scaling as values get larger
and larger.

Trying this out as a starting point.

(100 + DC) / (100 + save) = efficacy.
"""
class_name SavingThrows extends RefCounted

const SAVE_BASE_MAGIC_NUMBER: float = 100.0

static func calculate_save(entity: Entity, save_name: String, difficulty_class: float) -> float:
  """This will return the efficacy of the effect.

  This returns some floating point multiplier, from 0.25 -> 2.
  """
  var save_total: float = entity.derived_statistics.get(save_name).total_value
  # Roll some dice! For right now we'll start with 4d6 (but floating point).
  for _i in range(4):
    save_total += randf_range(1, 6)

  return clampf((SAVE_BASE_MAGIC_NUMBER + difficulty_class) / (SAVE_BASE_MAGIC_NUMBER + save_total), 0.25, 2.0)
  
