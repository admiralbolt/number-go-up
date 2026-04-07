"""Stat Ordering!
"""

class_name StatOrdering extends Resource

@export var stat_weights: Dictionary[String, float] = {}

static func make_default() -> StatOrdering:
  var stat_ordering = StatOrdering.new()
  var base_weight: float = 12.0

  for attr_name in Attributes.ALL_ATTRIBUTES:
    if attr_name == Attributes.LEVEL:
      continue
    
    stat_ordering.stat_weights[attr_name] = base_weight
    base_weight -= 1

  return stat_ordering

static func make_from_list(attr_list: Array[String]) -> StatOrdering:
  var stat_ordering = StatOrdering.new()
  var base_weight: float = 12.0

  for attr_name in attr_list:
    stat_ordering.stat_weights[attr_name] = base_weight
    base_weight -= 1

  return stat_ordering