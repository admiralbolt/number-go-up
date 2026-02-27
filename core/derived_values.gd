class_name DerivedValues extends Resource

static var derived_value_names: Array[String] = [
  "health",
  "mana",
  "stamina",
  "fortitude_save",
  "reflex_save",
  "will_save",
  "mind_save",
  "armor",
  "dodge"
]

@export var derived_values: Dictionary[String, DerivedValue] = {
  "health": DerivedValue.new("health", 100.0, {
    "constitution": 1.1,
    "strength": 0.4
  }),
  "mana": DerivedValue.new("mana", 50.0, {
    "intelligence": 1.2,
    "spirit": 0.5
  }),
  "stamina": DerivedValue.new("stamina", 75.0, {
    "constitution": 0.7,
    "wisdom": 0.5
  }),
  "fortitude_save": DerivedValue.new("fortitude_save", 0.0, {
    "constitution": 0.5,
    "strength": 0.2,
    "luck": 0.05
  }),
  "reflex_save": DerivedValue.new("reflex_save", 0.0, {
    "agility": 0.5,
    "dexterity": 0.2,
    "luck": 0.05,
  }),
  "will_save": DerivedValue.new("will_save", 0.0, {
    "wisdom": 0.5,
    "spirit": 0.2,
    "luck": 0.05,
  }),
  "mind_save": DerivedValue.new("mind_save", 0.0, {
    "intelligence": 0.5,
    "charisma": 0.2,
    "luck": 0.05,
  }),
  "armor": DerivedValue.new("armor", 0.0, {
    "constitution": 0.2,
    "strength": 0.04,
  }),
  "dodge": DerivedValue.new("dodge", 0.0, {
    "agility": 0.22
  }),
}

func _init() -> void:
  pass

func debug_print(attributes: Attributes, modifiers: Modifiers) -> void:
  print("Derived Values:")
  print("==============")
  for derived_value in derived_values.values():
    print("%s: %.2f" % [derived_value.name, derived_value.get_total_value(attributes, modifiers)])
  print("\n")


class DerivedValue extends Resource:

  var name: String = ""
  var base_value: float = 0.0
  var weights: Dictionary[String, float] = {}

  func _init(p_name: String, p_base_value: float, p_weights: Dictionary[String, float]) -> void:
    self.name = p_name
    self.base_value = p_base_value
    self.weights = p_weights

  func get_total_value(attributes: Attributes, modifiers: Modifiers) -> float:
    var val = base_value
    for attribute_name in weights.keys():
      if attributes.attributes.has(attribute_name):
        val += attributes.attributes[attribute_name].get_total_value(modifiers) * weights[attribute_name]
    val = modifiers.compute(val, "derived", name)
    return snapped(val, 0.01)

