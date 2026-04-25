class_name EquipmentSlotDisplay extends Control

@export var equipment_slot_type: Equipment.EquipmentSlot

@onready var item_icon: TextureRect = $PanelContainer/ItemIcon
@onready var background_icon: TextureRect = $PanelContainer/BackgroundIcon

var equipment: Item: set = _set_equipment

func _ready() -> void:
  background_icon.texture = Equipment.SLOT_ICONS[self.equipment_slot_type]
  self._update_icons()

  # TestItemManager.initialize()
  # if randf() < 0.5:
  #   self.equipment = TestItemManager.all_test_items.pick_random()

func _update_icons() -> void:
  if self.equipment == null:
    self.item_icon.texture = null
    self.background_icon.modulate = Color.from_rgba8(110, 100, 100, 180)
    return

  self.item_icon.texture = self.equipment.icon.atlas_texture
  self.background_icon.modulate = Color.from_rgba8(80, 80, 80, 75)

func _set_equipment(p_equipment: Item) -> void:
  equipment = p_equipment

  self._update_icons()
