class_name Modifiers extends Node


@export var active_modifiers: Array[Modifier] = []
# In addition to keeping track of the active modifiers in an array, we want
# a two level mapping of target + name for easy lookup when calculating
# derived values and skills.
@export var attribute_map: Dictionary[String, SubModifierList] = {}
@export var derived_map: Dictionary[String, SubModifierList] = {}
@export var skill_map: Dictionary[String, SubModifierList] = {}

func _init() -> void:
  # Initialize the maps with empty lists for each value.
  for attribute_name in Attributes.attribute_names:
    attribute_map[attribute_name] = SubModifierList.new()
  for derived_name in DerivedValues.derived_value_names:
    derived_map[derived_name] = SubModifierList.new()
  for skill_name in Skills.skill_names:
    skill_map[skill_name] = SubModifierList.new()

func _process(delta: float) -> void:
  for modifier in active_modifiers:
    modifier.duration -= delta
  active_modifiers = active_modifiers.filter(func(modifier):
    return modifier.duration > 0
  )

func add_modifier(modifier: Modifier) -> void:
  active_modifiers.append(modifier)
  # When we add a new modifier, we want to update all the corresponding maps
  # for quick lookup later.
  for sub_modifier in modifier.modifier_data:
    if sub_modifier.target_type == "attribute":
      attribute_map[sub_modifier.target_name].add_sub_modifier(sub_modifier)
    elif sub_modifier.target_type == "derived":
      derived_map[sub_modifier.target_name].add_sub_modifier(sub_modifier)
    elif sub_modifier.target_type == "skill":
      skill_map[sub_modifier.target_name].add_sub_modifier(sub_modifier)

func find_modifier(modifier_name: String) -> Modifier:
  for modifier in active_modifiers:
    if modifier.name == modifier_name:
      return modifier
  return null

func remove_modifier(modifier_name: String) -> void:
  var modifier_to_remove = find_modifier(modifier_name)
  if modifier_to_remove == null:
    print("Warning: Tried to remove modifier '%s' but it was not found." % modifier_name)
    return
   
  active_modifiers.erase(modifier_to_remove)
  # When removing, we also want to update the corresponding maps.
  for sub_modifier in modifier_to_remove.modifier_data:
    if sub_modifier.target_type == "attribute":
      attribute_map[sub_modifier.target_name].remove_sub_modifier(sub_modifier)
    elif sub_modifier.target_type == "derived":
      derived_map[sub_modifier.target_name].remove_sub_modifier(sub_modifier)
    elif sub_modifier.target_type == "skill":
      skill_map[sub_modifier.target_name].remove_sub_modifier(sub_modifier)

func compute(base_value: float, target_type: String, target_name: String) -> float:
  if target_type == "attribute" and attribute_map.has(target_name):
    return attribute_map[target_name].apply(base_value)
  elif target_type == "derived" and derived_map.has(target_name):
    return derived_map[target_name].apply(base_value)
  elif target_type == "skill" and skill_map.has(target_name):
    return skill_map[target_name].apply(base_value)
  
  return base_value


class Modifier extends Resource:
  var name: String = ""
  var source_type: String = ""
  var duration: float = 0.0
  var modifier_data: Array[SubModifier] = []

  func _init(p_name: String, p_source_type: String, p_duration: float, p_modifier_data: Array[SubModifier]) -> void:
    self.name = p_name
    self.source_type = p_source_type
    self.duration = p_duration
    self.modifier_data = p_modifier_data

class SubModifier extends Resource:
  enum ModifierType {
    Additive,
    Multiplicative
  }

  var target_type: String = ""
  var target_name: String = ""
  var value: float = 0.0
  var type: ModifierType = ModifierType.Additive

  func _init(p_target_type: String, p_target_name: String, p_value: float, p_type: ModifierType = ModifierType.Additive) -> void:
    self.target_type = p_target_type
    self.target_name = p_target_name
    self.value = p_value
    self.type = p_type

class SubModifierList extends Resource:
  var additive_sub_modifiers: Array[SubModifier] = []
  var multiplicative_sub_modifiers: Array[SubModifier] = []

  func _init() -> void:
    self.additive_sub_modifiers = []
    self.multiplicative_sub_modifiers = []

  func add_sub_modifier(sub_modifier: SubModifier) -> void:
    if sub_modifier.type == SubModifier.ModifierType.Additive:
      additive_sub_modifiers.append(sub_modifier)
    elif sub_modifier.type == SubModifier.ModifierType.Multiplicative:
      multiplicative_sub_modifiers.append(sub_modifier)

  func remove_sub_modifier(sub_modifier: SubModifier) -> void:
    if sub_modifier.type == SubModifier.ModifierType.Additive:
      additive_sub_modifiers.erase(sub_modifier)
    elif sub_modifier.type == SubModifier.ModifierType.Multiplicative:
      multiplicative_sub_modifiers.erase(sub_modifier)

  func apply(base_value: float) -> float:
    var val = base_value
    for sub_modifier in additive_sub_modifiers:
      val += sub_modifier.value
    for sub_modifier in multiplicative_sub_modifiers:
      val *= sub_modifier.value
    return val
