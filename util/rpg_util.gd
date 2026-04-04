class_name RPGUtil

static func get_attribute_level_bonus(level: int, numerator: float = 10.0) -> float:
  return numerator / sqrt(level)

static func total_xp_for_next_level(level: int) -> float:
  return snapped(500 * (level ** 2.4 + level ** 1.7 + level ** 1.2), 500)

static func total_xp_for_next_skill_level(level: int) -> float:
  return snapped(500 * (level ** 2.4 + level ** 1.7 + level ** 1.2), 500)

static func compute_armor_reduction(armor: float) -> float:
  return 100 / (100 + armor)

static func calculate_damage(_owner: Entity, target: Entity, min_damage: float, max_damage: float, skill_bonus: float) -> float:
  # Eventually we'll probably want other stuff from the owner. For right now
  # I can't think of anything direct.
  # print("Calculating damage from %s to %s with min_damage: %f, max_damage: %f, skill_bonus: %f" % [_owner.name, target.name, min_damage, max_damage, skill_bonus])
  var damage: float = randf_range(min_damage, max_damage) + skill_bonus

  # Armor....
  damage *= compute_armor_reduction(target.derived_statistics.armor.total_value)

  return damage
