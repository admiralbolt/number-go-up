class_name Equipment extends Item

signal equip_changed()

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
  SHIELD,
  UNDEFINED,
}

static var SLOT_ICONS: Dictionary[EquipmentSlot, Texture2D] = {
  EquipmentSlot.HEAD: preload("res://assets/ui/pause_menu/equip/head_slot.svg"),
  EquipmentSlot.BODY: preload("res://assets/ui/pause_menu/equip/body_slot.svg"),
  EquipmentSlot.LEGS: preload("res://assets/ui/pause_menu/equip/legs_slot.svg"),
  EquipmentSlot.FEET: preload("res://assets/ui/pause_menu/equip/feet_slot.svg"),
  EquipmentSlot.ARMS: preload("res://assets/ui/pause_menu/equip/arms_slot.svg"),
  EquipmentSlot.HANDS: preload("res://assets/ui/pause_menu/equip/hands_slot.svg"),
  EquipmentSlot.SHOULDERS: preload("res://assets/ui/pause_menu/equip/shoulders_slot.svg"),
  EquipmentSlot.WAIST: preload("res://assets/ui/pause_menu/equip/waist_slot.svg"),
  EquipmentSlot.NECK: preload("res://assets/ui/pause_menu/equip/neck_slot.svg"),
  EquipmentSlot.EARRINGS: preload("res://assets/ui/pause_menu/equip/earrings_slot.svg"),
  EquipmentSlot.RING_LEFT: preload("res://assets/ui/pause_menu/equip/ring_left_slot.svg"),
  EquipmentSlot.RING_RIGHT: preload("res://assets/ui/pause_menu/equip/ring_right_slot.svg"),
  EquipmentSlot.WEAPON: preload("res://assets/ui/pause_menu/equip/weapon_slot.svg"),
  EquipmentSlot.SHIELD: preload("res://assets/ui/pause_menu/equip/shield_slot.svg")
}

enum EquipmentType {
  WEAPON,
  ARMOR,
  SHIELD,
  ACCESSORY
}

@export var equipment_type: EquipmentType
# The primary slot this item goes into.
@export var slot: EquipmentSlot
# An extra slot the item might take up. Think two-handed swords taking up the
# shield slot, cloaks with hoods e.t.c.
@export var secondary_slot: EquipmentSlot = EquipmentSlot.UNDEFINED
@export var attribute_requirements: Dictionary[String, float] = {}
@export var level_requirement: int = 0

@export var modifiers: Array[Modifier] = []
# Spooky.
@export var is_cursed: bool = false

# Is currently equipped.
@export var is_equipped: bool = false: set = _set_is_equipped

func _init() -> void:
  self.is_stackable = false
  self.is_sellable = true
  self.is_usable = false
  self.item_type = Item.ItemType.EQUIPMENT

func can_equip(entity: Entity) -> bool:
  for attribute_name in self.attribute_requirements.keys():
    if entity.attributes.get(attribute_name).total_value < attribute_requirements[attribute_name]:
      return false

  return PlayerManager.player.level >= level_requirement

func can_remove() -> bool:
  return not self.is_cursed

func get_slots() -> Array[EquipmentSlot]:
  var slots: Array[EquipmentSlot] = [self.slot]
  if self.secondary_slot != EquipmentSlot.UNDEFINED:
    slots.append(self.secondary_slot)

  return slots

# When the thing is equipped. This should be called by children if overriden.
func on_equip() -> void:
  for modifier in self.modifiers:
    PlayerManager.player.modifier_manager.add_modifier(modifier)
  self.is_equipped = true

# When the thing is removed. This should be called by children if overriden.
func on_remove() -> void:
  for modifier in self.modifiers:
    PlayerManager.player.modifier_manager.remove_modifier(modifier)
  self.is_equipped = false

func _set_is_equipped(p_is_equipped: bool) -> void:
  is_equipped = p_is_equipped
  self.equip_changed.emit()
