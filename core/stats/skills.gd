class_name Skills extends Resource

const SWORDS: String = "swords"

@export var swords: Skill = Skill.make(SWORDS, 1, 0.0, {
  Attributes.STRENGTH: 0.2,
  Attributes.DEXTERITY: 0.1,
})

func initialize(p_entity: Entity) -> void:
  for skill in [swords]:
    skill.initialize(p_entity)

func debug_print() -> void:
  print("Skills:")
  for skill in [swords]:
    print("  %s" % skill)