class_name Skills extends Resource

static var skill_names: Array[String] = ["swords", "axes"]

@export var skills: Dictionary[String, Skill] = {
  "swords": Skill.new("swords", 1, 0.0, {
    "strength": 0.6,
    "dexterity": 0.35,
    "agility": 0.05
  }),
  "axes": Skill.new("axes", 1, 0.0, {
    "strength": 0.7,
    "dexterity": 0.2,
    "constitution": 0.1
  }),
}

func debug_print(attributes: Attributes, modifiers: Modifiers) -> void:
  print("Skills:")
  print("==============")
  for skill in skills.values():
    print("%s: %.2f (Level %d, XP %.2f)" % [skill.name, skill.get_total_value(attributes, modifiers), skill.level, skill.xp])
  print("\n")


class Skill extends Resource:

  var name: String = ""
  var level: int = 1
  var xp: float = 0.0
  var xp_to_next_level: float = 1000.0
  var weights: Dictionary[String, float] = {}

  func _init(p_name: String, p_level: int, p_xp: float, p_weights: Dictionary[String, float]) -> void:
    self.name = p_name
    self.level = p_level
    self.xp = p_xp
    self.xp_to_next_level = get_xp_for_next_level()
    self.weights = p_weights

  func get_total_value(attributes: Attributes, modifiers: Modifiers) -> float:
    var val: float = level
    for attribute_name in weights.keys():
      if attributes.attributes.has(attribute_name):
        val += attributes.attributes[attribute_name].get_total_value(modifiers) * weights[attribute_name]
    val = modifiers.compute(val, "skill", name)
    return snapped(val, 0.01)

  func get_xp_for_next_level() -> float:
    return 500 * (level ** 2.4 + level ** 1.7 + level ** 1.2)

  func add_xp(amount: float) -> void:
    xp += amount
    while xp >= xp_to_next_level:
      level += 1
      xp_to_next_level = get_xp_for_next_level()
      SignalBus.skill_level_up.emit(name, level)