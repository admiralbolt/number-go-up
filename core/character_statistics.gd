class_name CharacterStatistics extends Resource


## TEST ##
###########
@export var current_hp: float = 100.0: set = _on_health_set
signal health_changed(p_health: float, p_max_health: float)

func _on_health_set(value: float) -> void:
  print("Setting current health to: ", value)
  current_hp = value
  health_changed.emit(current_hp, total_max_health)

## BASE ##
###########
@export var level: int = 1
@export var experience: float = 0.0

### ATTRIBUTES ###
##################

static var ATTRIBUTE_NAMES = [
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

@export var base_strength: float = 10.0
@export var base_constitution: float = 10.0
@export var base_dexterity: float = 10.0
@export var base_agility: float = 10.0
@export var base_spirit: float = 10.0
@export var base_wisdom: float = 10.0
@export var base_intelligence: float = 10.0
@export var base_charisma: float = 10.0
@export var base_luck: float = 10.0

var total_strength: float = 10.0
var total_constitution: float = 10.0
var total_dexterity: float = 10.0
var total_agility: float = 10.0
var total_spirit: float = 10.0
var total_wisdom: float = 10.0
var total_intelligence: float = 10.0
var total_charisma: float = 10.0
var total_luck: float = 10.0

### DERIVED VALUES ###
######################

class DerivedFormula extends Resource:
  var name: String = ""
  var base_value: float = 0.0
  var weights: Dictionary[String, float] = {}

  func _init(p_name: String, p_base_value: float, p_weights: Dictionary[String, float]) -> void:
    self.name = p_name
    self.base_value = p_base_value
    self.weights = p_weights

  func get_base_value(attributes: CharacterStatistics) -> float:
    var val = base_value
    for attribute_name in weights.keys():
      var total_key = "total_" + attribute_name
      if total_key in attributes:
        val += attributes.get(total_key) * weights[attribute_name]
      else:
        val += attributes.get(attribute_name) * weights[attribute_name]
    return val

static var DERIVED_VALUE_NAMES = [
  "max_health",
  "max_mana",
  "max_stamina",
  "fortitude_save",
  "reflex_save",
  "will_save",
  "mind_save",
  "armor",
  "dodge"
]

static var DERIVED_VALUE_FORMULAS = {
  "max_health": DerivedFormula.new("health", 100.0, {
    "level": 10.0,
    "constitution": 0.8,
    "strength": 0.3,
    "dexterity": 0.1,
    "agility": 0.04
  }),
  "max_mana": DerivedFormula.new("mana", 100.0, {
    "level": 10.0,
    "intelligence": 1.2,
    "spirit": 0.5
  }),
  "max_stamina": DerivedFormula.new("stamina", 100.0, {
    "level": 10.0,
    "constitution": 0.7,
    "wisdom": 0.5
  }),
  "fortitude_save": DerivedFormula.new("fortitude_save", 0.0, {
    "constitution": 0.5,
    "strength": 0.2,
    "luck": 0.05,
  }),
  "reflex_save": DerivedFormula.new("reflex_save", 0.0, {
    "agility": 0.5,
    "dexterity": 0.2,
    "luck": 0.05,
  }),
  "will_save": DerivedFormula.new("will_save", 0.0, {
    "wisdom": 0.5,
    "spirit": 0.2,
    "luck": 0.05,
  }),
  "mind_save": DerivedFormula.new("mind_save", 0.0, {
    "intelligence": 0.5,
    "charisma": 0.2,
    "luck": 0.05,
  }),
  "armor": DerivedFormula.new("armor", 0.0, {
    "constitution": 0.2,
    "strength": 0.04,
  }),
  "dodge": DerivedFormula.new("dodge", 0.0, {
    "agility": 0.22,
    "luck": 0.01
  }),
  "move_speed": DerivedFormula.new("move_speed", 100.0, {
    "agility": 0.1,
    "dexterity": 0.02,
    "strength": 0.01
  })
}

@export var base_max_health: float = 100.0
@export var base_max_mana: float = 100.0
@export var base_max_stamina: float = 100.0
@export var base_fortitude_save: float = 0.0
@export var base_reflex_save: float = 0.0
@export var base_will_save: float = 0.0
@export var base_mind_save: float = 0.0
@export var base_armor: float = 0.0
@export var base_dodge: float = 0.0
@export var base_move_speed: float = 100.0

var total_max_health: float = 100.0
var total_max_mana: float = 100.0
var total_max_stamina: float = 100.0
var total_fortitude_save: float = 0.0
var total_reflex_save: float = 0.0
var total_will_save: float = 0.0
var total_mind_save: float = 0.0
var total_armor: float = 0.0
var total_dodge: float = 0.0
var total_move_speed: float = 100.0

func recompute_total_values(modifiers: Modifiers) -> void:
  for attribute_name in ATTRIBUTE_NAMES:
    set("total_" + attribute_name, modifiers.compute(get("base_" + attribute_name), Modifiers.SubModifier.TargetType.Stat, attribute_name))

  for derived_value_name in DERIVED_VALUE_NAMES:
    set("base_" + derived_value_name, DERIVED_VALUE_FORMULAS[derived_value_name].get_base_value(self))
    set("total_" + derived_value_name, modifiers.compute(get("base_" + derived_value_name), Modifiers.SubModifier.TargetType.Stat, derived_value_name))
 

func debug_print() -> void:
  print("Character Statistics:")
  print("=====================")
  print("Level: %d, Experience: %.2f" % [level, experience])
  print("\nAttributes:")
  for attribute_name in ATTRIBUTE_NAMES:
    print("%s: %.2f" % [attribute_name.capitalize(), get("total_" + attribute_name)])
  print("\nDerived Values:")
  for derived_value_name in DERIVED_VALUE_NAMES:
    print("%s: %.2f" % [derived_value_name.capitalize(), get("total_" + derived_value_name)])