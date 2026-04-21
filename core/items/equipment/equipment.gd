class_name Equipment extends Item

enum EquipmentSlot {
  HEAD,
  BODY,
  LEGS,
  FEET,
  ARMS,
  HANDS,
  SHOULDERS,
  WAIST,
  NECK,
  RING_LEFT,
  RING_RIGHT,
  WEAPON_LEFT,
  WEAPON_RIGHT
}

enum EquipmentType {
  WEAPON,
  ARMOR,
  SHIELD,
  ACCESSORY
}

@export var equipment_type: EquipmentType
@export var slots: Array[EquipmentSlot] = []
@export var attribute_requirements: Dictionary[String, float] = {}

@export var modifiers: Array[Modifier] = []
# Spooky.
@export var is_cursed: bool = false

func can_equip() -> bool:
  for attribute_name in attribute_requirements.keys():
    if not PlayerManager.player.attributes.attributes.has(attribute_name):
      return false

    if PlayerManager.player.attributes.get(attribute_name).total_value < attribute_requirements[attribute_name]:
      return false

  return true

func can_remove() -> bool:
  return not self.is_cursed


# When the thing is equipped. This should be called by children if overriden.
func on_equip() -> void:
  for modifier in modifiers:
    PlayerManager.player.modifier_manager.add_modifier(modifier)

# When the thing is removed. This should be called by children if overriden.
func on_remove() -> void:
  for modifier in modifiers:
    PlayerManager.player.modifier_manager.remove_modifier(modifier)
