class_name Skills extends Resource

# Weapons
const SWORDS: String = "swords"
const AXES: String = "axes"
const HAMMERS: String = "hammers"
const SPEARS: String = "spears"
const BOWS: String = "bows"
const UNARMED: String = "unarmed"
const THROWING: String = "throwing"

# Magic
const ALTERATION: String = "alteration"
const CONJURATION: String = "conjuration"
const DESTRUCTION: String = "destruction"
const ENCHANTING: String = "enchanting"
const ILLUSION: String = "illusion"
const NECROMANCY: String = "necromancy"
const RESTORATION: String = "restoration"

# Gathering & crafting
const MINING: String = "mining"
const SMITHING: String = "smithing"

const WOODCUTTING: String = "woodcutting"
const CONSTRUCTION: String = "construction"
const FLETCHING: String = "fletching"

const FISHING: String = "fishing"
const COOKING: String = "cooking"

const ALCHEMY: String = "alchemy"
const TINKERING: String = "tinkering"

# Physical skills
const ACROBATICS: String = "acrobatics"
const CLIMB: String = "climb"
const SWIM: String = "swim"
const STEALTH: String = "stealth"

# Social skills
const PERSUASION: String = "persuasion"
const INTIMIDATION: String = "intimidation"
const HANDLE_ANIMAL: String = "handle_animal"
const PERFORMANCE: String = "performance"

# Misc
const APPRAISAL: String = "appraisal"
const PERCEPTION: String = "perception"

const ALL_SKILLS: Array[String] = [
  SWORDS, AXES, HAMMERS, SPEARS, BOWS, UNARMED, THROWING,
  ALTERATION, CONJURATION, DESTRUCTION, ENCHANTING, ILLUSION, NECROMANCY, RESTORATION,
  MINING, SMITHING, WOODCUTTING, CONSTRUCTION, FLETCHING, FISHING, COOKING, ALCHEMY, TINKERING,
  ACROBATICS, CLIMB, SWIM, STEALTH,
  PERSUASION, INTIMIDATION, HANDLE_ANIMAL, PERFORMANCE,
  APPRAISAL, PERCEPTION,
]

# Weapons
@export var swords: Skill = Skill.make_default(SWORDS, {
  Attributes.STRENGTH: 0.1,
  Attributes.DEXTERITY: 0.05,
})

@export var axes: Skill = Skill.make_default(AXES, {
  Attributes.STRENGTH: 0.14,
  Attributes.DEXTERITY: 0.02,
})

@export var hammers: Skill = Skill.make_default(HAMMERS, {
  Attributes.STRENGTH: 0.125,
  Attributes.CONSTITUTION: 0.015,
})

@export var spears: Skill = Skill.make_default(SPEARS, {
  Attributes.STRENGTH: 0.07,
  Attributes.DEXTERITY: 0.07,
})

@export var bows: Skill = Skill.make_default(BOWS, {
  Attributes.STRENGTH: 0.05,
  Attributes.DEXTERITY: 0.125,
})

@export var unarmed: Skill = Skill.make_default(UNARMED, {
  Attributes.STRENGTH: 0.084,
  Attributes.DEXTERITY: 0.064,
})

@export var throwing: Skill = Skill.make_default(THROWING, {
  Attributes.STRENGTH: 0.09,
  Attributes.DEXTERITY: 0.08,
})

# Magic.
@export var alteration: Skill = Skill.make_default(ALTERATION, {
  Attributes.INTELLIGENCE: 0.05,
  Attributes.WISDOM: 0.05,
  Attributes.SPIRIT: 0.05,
})

@export var conjuration: Skill = Skill.make_default(CONJURATION, {
  Attributes.INTELLIGENCE: 0.1,
  Attributes.CHARISMA: 0.05,
})

@export var destruction: Skill = Skill.make_default(DESTRUCTION, {
  Attributes.INTELLIGENCE: 0.05,
  Attributes.SPIRIT: 0.1,
})

@export var enchanting: Skill = Skill.make_default(ENCHANTING, {
  Attributes.INTELLIGENCE: 0.12,
})

@export var illusion: Skill = Skill.make_default(ILLUSION, {
  Attributes.WISDOM: 0.05,
  Attributes.SPIRIT: 0.05,
  Attributes.CHARISMA: 0.1,
})

@export var necromancy: Skill = Skill.make_default(NECROMANCY, {
  Attributes.SPIRIT: 0.1,
  Attributes.CHARISMA: 0.05,
})

@export var restoration: Skill = Skill.make_default(RESTORATION, {
  Attributes.WISDOM: 0.1,
  Attributes.SPIRIT: 0.05,
})

# Gathering & crafting
@export var mining: Skill = Skill.make_default(MINING, {
  Attributes.STRENGTH: 0.09,
  Attributes.CONSTITUTION: 0.05,
  Attributes.WISDOM: 0.02,
  Attributes.LUCK: 0.01,
})

@export var smithing: Skill = Skill.make_default(SMITHING, {
  Attributes.STRENGTH: 0.04,
  Attributes.DEXTERITY: 0.08,
  Attributes.INTELLIGENCE: 0.04
})

@export var woodcutting: Skill = Skill.make_default(WOODCUTTING, {
  Attributes.STRENGTH: 0.09,
  Attributes.CONSTITUTION: 0.05,
  Attributes.WISDOM: 0.02,
  Attributes.LUCK: 0.01,
})

@export var construction: Skill = Skill.make_default(CONSTRUCTION, {
  Attributes.STRENGTH: 0.07,
  Attributes.DEXTERITY: 0.05,
  Attributes.INTELLIGENCE: 0.04,
})

@export var fletching: Skill = Skill.make_default(FLETCHING, {
  Attributes.DEXTERITY: 0.1,
  Attributes.INTELLIGENCE: 0.05,
})

@export var fishing: Skill = Skill.make_default(FISHING, {
  Attributes.DEXTERITY: 0.06,
  Attributes.WISDOM: 0.06,
  Attributes.LUCK: 0.04,
})

@export var cooking: Skill = Skill.make_default(COOKING, {
  Attributes.DEXTERITY: 0.04,
  Attributes.INTELLIGENCE: 0.05,
  Attributes.WISDOM: 0.05,
})

@export var alchemy: Skill = Skill.make_default(ALCHEMY, {
  Attributes.DEXTERITY: 0.03,
  Attributes.INTELLIGENCE: 0.12
})

@export var tinkering: Skill = Skill.make_default(TINKERING, {
  Attributes.DEXTERITY: 0.11,
  Attributes.INTELLIGENCE: 0.02,
  Attributes.WISDOM: 0.02,
})

# Physical skills
@export var acrobatics: Skill = Skill.make_default(ACROBATICS, {
  Attributes.STRENGTH: 0.04,
  Attributes.AGILITY: 0.12,
})

@export var climb: Skill = Skill.make_default(CLIMB, {
  Attributes.STRENGTH: 0.1,
  Attributes.CONSTITUTION: 0.05,
  Attributes.DEXTERITY: 0.01
})

@export var swim: Skill = Skill.make_default(SWIM, {
  Attributes.STRENGTH: 0.07,
  Attributes.CONSTITUTION: 0.05,
  Attributes.AGILITY: 0.04,
})

@export var stealth: Skill = Skill.make_default(STEALTH, {
  Attributes.AGILITY: 0.13,
  Attributes.DEXTERITY: 0.03,
})

# Social skills.
@export var persuasion: Skill = Skill.make_default(PERSUASION, {
  Attributes.CHARISMA: 0.12,
  Attributes.SPIRIT: 0.04,
})

@export var intimidation: Skill = Skill.make_default(INTIMIDATION, {
  Attributes.CHARISMA: 0.12,
  Attributes.STRENGTH: 0.04,
})

@export var handle_animal: Skill = Skill.make_default(HANDLE_ANIMAL, {
  Attributes.CHARISMA: 0.12,
  Attributes.WISDOM: 0.04,
})

@export var performance: Skill = Skill.make_default(PERFORMANCE, {
  Attributes.CHARISMA: 0.12,
  Attributes.DEXTERITY: 0.04,
})

# Misc.
@export var appraisal: Skill = Skill.make_default(APPRAISAL, {
  Attributes.INTELLIGENCE: 0.11,
  Attributes.WISDOM: 0.04,
})

@export var perception: Skill = Skill.make_default(PERCEPTION, {
  Attributes.WISDOM: 0.11,
  Attributes.INTELLIGENCE: 0.04,
})


func initialize(p_entity: Entity) -> void:
  for skill_name in ALL_SKILLS:
    var skill: Skill = self.get(skill_name)
    skill.initialize(p_entity)

func debug_print() -> void:
  print("Skills:")
  for skill_name in ALL_SKILLS:
    var skill: Skill = self.get(skill_name)
    print("  %s" % skill)

func _analysis() -> void:
  var attr_count: Dictionary[String, int] = {}
  var attr_total_weight: Dictionary[String, float] = {}
  for skill_name in ALL_SKILLS:
    var skill: Skill = self.get(skill_name)
    for attr_name in skill.weights.keys():
      if attr_name not in attr_count:
        attr_count[attr_name] = 0
        attr_total_weight[attr_name] = 0.0

      attr_count[attr_name] += 1
      attr_total_weight[attr_name] += skill.weights[attr_name]

  print("There's a total of %d skills." % ALL_SKILLS.size())
  print("Attribute analysis of all skills:")
  for attr_name in attr_count.keys():
    print("  %s: appears in %d skills, total weight %.2f" % [attr_name, attr_count[attr_name], attr_total_weight[attr_name]])