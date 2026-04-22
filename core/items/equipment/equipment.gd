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
  EARRINGS,
  RING_LEFT,
  RING_RIGHT,
  WEAPON,
  SHIELD
}

static var SLOT_ICONS: Dictionary[EquipmentSlot, Texture2D] = {
  EquipmentSlot.HEAD: preload("res://assets/ui/inventory/equip_background/helmet_slot.svg"),
  EquipmentSlot.BODY: preload("res://assets/ui/inventory/equip_background/body_slot.svg"),
  EquipmentSlot.LEGS: preload("res://assets/ui/inventory/equip_background/leg_slot.svg"),
  EquipmentSlot.FEET: preload("res://assets/ui/inventory/equip_background/feet_slot.svg"),
  EquipmentSlot.ARMS: preload("res://assets/ui/inventory/equip_background/arm_slot.svg"),
  EquipmentSlot.HANDS: preload("res://assets/ui/inventory/equip_background/hand_slot.svg"),
  EquipmentSlot.SHOULDERS: preload("res://assets/ui/inventory/equip_background/shoulder_slot.svg"),
  EquipmentSlot.WAIST: preload("res://assets/ui/inventory/equip_background/waist_slot.svg"),
  EquipmentSlot.NECK: preload("res://assets/ui/inventory/equip_background/neck_slot.svg"),
  EquipmentSlot.EARRINGS: preload("res://assets/ui/inventory/equip_background/earrings_slot.svg"),
  EquipmentSlot.RING_LEFT: preload("res://assets/ui/inventory/equip_background/ring_left_slot.svg"),
  EquipmentSlot.RING_RIGHT: preload("res://assets/ui/inventory/equip_background/ring_right_slot.svg"),
  EquipmentSlot.WEAPON: preload("res://assets/ui/inventory/equip_background/weapon_slot.svg"),
  EquipmentSlot.SHIELD: preload("res://assets/ui/inventory/equip_background/shield_slot.svg")
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
@export var level_requirement: int = 0

@export var modifiers: Array[Modifier] = []
# Spooky.
@export var is_cursed: bool = false

func can_equip() -> bool:
  for attribute_name in attribute_requirements.keys():
    if not PlayerManager.player.attributes.attributes.has(attribute_name):
      return false

    if PlayerManager.player.attributes.get(attribute_name).total_value < attribute_requirements[attribute_name]:
      return false

  return PlayerManager.player.level >= level_requirement

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

