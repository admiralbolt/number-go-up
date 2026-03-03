class_name Equipment extends Resource

enum EquipmentSlot {
  Head,
  Body,
  Legs,
  Feet,
  Arms,
  Hands,
  Shoulders,
  Waist,
  Neck,
  Ring,
}

@export var name: String = ""
@export var description: String = ""
@export var slot: EquipmentSlot = EquipmentSlot.Head
@export var modifier: Modifiers.Modifier = null
@export var attribute_requirements: Dictionary[String, float] = {}



func can_equip(attributes: Attributes) -> bool:
  for attribute_name in attribute_requirements.keys():
    if not attributes.attributes.has(attribute_name):
      return false
    if attributes.attributes[attribute_name].get_total_value(Modifiers.new()) < attribute_requirements[attribute_name]:
      return false
  return true