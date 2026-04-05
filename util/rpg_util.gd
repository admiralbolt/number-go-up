class_name RPGUtil

static func get_attribute_level_bonus(level: int, numerator: float = 10.0) -> float:
  return numerator / sqrt(level)

static func total_xp_for_next_level(level: int) -> float:
  return snapped(500 * (level ** 2.4 + level ** 1.7 + level ** 1.2), 500)

static func total_xp_for_next_skill_level(level: int) -> float:
  return snapped(500 * (level ** 2.4 + level ** 1.7 + level ** 1.2), 500)
