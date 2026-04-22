class_name EquipmentSlotDisplay extends Control

@export var equipment_slot_type: Equipment.EquipmentSlot

@onready var item_icon: TextureRect = $PanelContainer/ItemIcon
@onready var background_icon: TextureRect = $PanelContainer/BackgroundIcon

var equipment: Item: set = _set_equipment

func _ready() -> void:
  background_icon.modulate = Color.from_rgba8(110, 110, 110, 200)
  background_icon.texture = Equipment.SLOT_ICONS[self.equipment_slot_type]

  TestItemManager.initialize()
  if randf() < 0.5:
    self.equipment = TestItemManager.all_test_items.pick_random()

func _set_equipment(p_equipment: Item) -> void:
  equipment = p_equipment

  if equipment == null:
    item_icon.texture = null
    background_icon.modulate = Color.from_rgba8(110, 110, 110, 180)
    return

  print("Setting equipment: %s" % equipment.name)
  item_icon.texture = equipment.icon.atlas_texture
  background_icon.modulate = Color.from_rgba8(80, 80, 80, 75)
