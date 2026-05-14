"""Manages equipment for an entity!"""
class_name EquipmentManager

signal equipment_equipped(equipment: Equipment)
signal equipment_removed(equipment: Equipment)

var entity: Entity
var equipped_items: Dictionary[Equipment.EquipmentSlot, Equipment] = {}

func _init(p_entity: Entity) -> void:
  self.entity = p_entity

  # On init, we set all slots to empty.
  for slot in Equipment.EquipmentSlot.values():
    equipped_items[slot] = null

func reinitialize(equipment_list: Array[Equipment]) -> void:
  for equipment in equipment_list:
    self.equip(equipment)

func is_type_equipped(equipment_type: Equipment.EquipmentSlot) -> bool:
  return self.equipped_items.get(equipment_type, null) != null

func is_equipped(equipment: Equipment) -> bool:
  return equipment in self.equipped_items.values()

func unequip(equipment: Equipment) -> bool:
  if not self.is_equipped(equipment):
    return false

  if not equipment.can_remove():
    return false

  for slot in equipment.get_slots():
    self.remove_equipment_by_slot(slot)

  return true

func equip(equipment: Equipment) -> bool:
  if not equipment.can_equip(self.entity):
    return false

  # In certain cases, a single piece of equipment takes up multiple slots.
  # First we check to see if any of the slots are already occupied AND they
  # can be removed.
  for slot in equipment.get_slots():
    if self.is_type_equipped(slot) and not self.equipped_items[slot].can_remove():
      # If we find an item we can't remove, just exit immediately.
      return false

    self.remove_equipment_by_slot(slot)

  # With all the other things removed, we can equip the item! Set it in the
  # slot, and apply all its modifiers.
  for slot in equipment.get_slots():
    self.equipped_items[slot] = equipment
  equipment.on_equip()
  self.equipment_equipped.emit(equipment)

  return true

func remove_equipment_by_slot(slot: Equipment.EquipmentSlot) -> bool:
  if self.equipped_items.get(slot, null) == null:
    return false

  if not self.equipped_items[slot].can_remove():
    return false

  self.equipped_items[slot].on_remove()
  if self.equipped_items[slot].secondary_slot != Equipment.EquipmentSlot.UNDEFINED:
    self.equipped_items.erase(self.equipped_items[slot].secondary_slot)

  self.equipment_removed.emit(self.equipped_items[slot])
  self.equipped_items.erase(slot)
  
  return true

func get_equipped_items() -> Array[Equipment]:
  var equipment: Array[Equipment]
  for value in self.equipped_items.values():
    if value != null:
      equipment.append(value)
  return equipment
  
