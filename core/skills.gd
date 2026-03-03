class_name Skills extends Resource

static var SKILL_NAMES: Array[String] = [
  "swords",
  "axes"
]

@export var swords: Skill = Skill.new("swords", 1, 0.0, {
  "strength": 0.6,
  "dexterity": 0.35,
  "agility": 0.05
})

@export var axes: Skill = Skill.new("axes", 1, 0.0, {
  "strength": 0.7,
  "dexterity": 0.2,
  "constitution": 0.1
})


func debug_print() -> void:
  print("Skills:")
  print("==============")
  for skill_name in SKILL_NAMES:
    var skill = self.get(skill_name)
    skill.debug_print()
  print("\n")

func recompute_total_values(character_statistics: CharacterStatistics, modifiers: Modifiers) -> void:
  for skill_name in SKILL_NAMES:
    var skill = self.get(skill_name)
    skill.recompute_total_value(character_statistics, modifiers)
