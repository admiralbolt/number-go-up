class_name Attributes extends Resource

const STRENGTH: String = "strength"
const CONSTITUTION: String = "constitution"
const DEXTERITY: String = "dexterity"
const AGILITY: String = "agility"
const SPIRIT: String = "spirit"
const WISDOM: String = "wisdom"
const INTELLIGENCE: String = "intelligence"
const CHARISMA: String = "charisma"
const LUCK: String = "luck"

const ALL_ATTRIBUTES: Array = [
  STRENGTH,
  CONSTITUTION,
  DEXTERITY,
  AGILITY,
  SPIRIT,
  WISDOM,
  INTELLIGENCE,
  CHARISMA,
  LUCK,
]

@export var strength: Attribute = Attribute.make(STRENGTH, 50.0)
@export var constitution: Attribute = Attribute.make(CONSTITUTION, 50.0)
@export var dexterity: Attribute = Attribute.make(DEXTERITY, 50.0)
@export var agility: Attribute = Attribute.make(AGILITY, 50.0)
@export var spirit: Attribute = Attribute.make(SPIRIT, 50.0)
@export var wisdom: Attribute = Attribute.make(WISDOM, 50.0)
@export var intelligence: Attribute = Attribute.make(INTELLIGENCE, 5000.0)
@export var charisma: Attribute = Attribute.make(CHARISMA, 50.0)
@export var luck: Attribute = Attribute.make(LUCK, 50.0)

func initialize(p_entity: Entity) -> void:
  for attr in [strength, constitution, dexterity, agility, spirit, wisdom, intelligence, charisma, luck]:
    attr.entity = p_entity
    attr.compute_total()


func debug_print() -> void:
  print("Attributes:")
  for attr in [strength, constitution, dexterity, agility, spirit, wisdom, intelligence, charisma, luck]:
    print("  %s" % attr)