# The 9 basic attributes of a character.
class_name Attributes extends Resource

static var attribute_names: Array[String] = [
  "strength",
  "constitution",
  "dexterity",
  "agility",
  "spirit",
  "wisdom",
  "intelligence",
  "charisma",
  "luck"
]

@export var attributes: Dictionary[String, Attribute] = {
  "strength": Attribute.new("strength", 10.0),
  "constitution": Attribute.new("constitution", 10.0),
  "dexterity": Attribute.new("dexterity", 10.0),
  "agility": Attribute.new("agility", 10.0),
  "spirit": Attribute.new("spirit", 10.0),
  "wisdom": Attribute.new("wisdom", 10.0),
  "intelligence": Attribute.new("intelligence", 10.0),
  "charisma": Attribute.new("charisma", 10.0),
  "luck": Attribute.new("luck", 10.0)
}

func _init(p_strength, p_constitution, p_dexterity, p_agility, p_spirit, p_wisdom, p_intelligence, p_charisma, p_luck) -> void:
  attributes["strength"] = Attribute.new("strength", p_strength)
  attributes["constitution"] = Attribute.new("constitution", p_constitution)
  attributes["dexterity"] = Attribute.new("dexterity", p_dexterity)
  attributes["agility"] = Attribute.new("agility", p_agility)
  attributes["spirit"] = Attribute.new("spirit", p_spirit)
  attributes["wisdom"] = Attribute.new("wisdom", p_wisdom)
  attributes["intelligence"] = Attribute.new("intelligence", p_intelligence)
  attributes["charisma"] = Attribute.new("charisma", p_charisma)
  attributes["luck"] = Attribute.new("luck", p_luck)

func debug_print(modifiers: Modifiers) -> void:
  print("Attributes:")
  print("==============")
  for attribute in attributes.values():
    print("%s: total: %.2f (base: %.2f)" % [attribute.name, attribute.get_total_value(modifiers), attribute.base_value])
  print("\n")


class Attribute extends Resource:
  var name: String = ""
  var base_value: float = 0.0

  func _init(p_name, p_base_value) -> void:
    self.name = p_name
    self.base_value = p_base_value

  func get_total_value(modifiers: Modifiers) -> float:
    return snapped(modifiers.compute(base_value, "attribute", name), 0.01)