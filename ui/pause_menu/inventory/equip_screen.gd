class_name EquipScreen extends Control

var inventory: Inventory: set = _set_inventory
var equipment_slot: Equipment.EquipmentSlot = Equipment.EquipmentSlot.UNDEFINED: set = _set_equipment_slot

@onready var equipment_display: EquipmentDisplay = $EquipmentDisplay
@onready var inventory_display: InventoryDisplay = $InventoryDisplay

func _ready() -> void:
  self.inventory_display.inventory = self.inventory
  self.inventory_display.equipment_slot = self.equipment_slot
  self.inventory_display.render()
  self.focus_entered.connect(self._on_focus_entered)

func _on_focus_entered() -> void:
  self.inventory_display.grab_focus()

func _set_inventory(p_inventory: Inventory) -> void:
  inventory = p_inventory

func _set_equipment_slot(p_equipment_slot: Equipment.EquipmentSlot) -> void:
  equipment_slot = p_equipment_slot
  if self.inventory_display != null:
    self.inventory_display.equipment_slot = equipment_slot
