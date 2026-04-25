class_name EquipmentDisplay extends Control

# Annoying but finite.
@onready var head_slot_display: EquipmentSlotDisplay = $HeadSlotDisplay
@onready var earrings_slot_display: EquipmentSlotDisplay = $EarringsSlotDisplay
@onready var shoulders_slot_display: EquipmentSlotDisplay = $ShouldersSlotDisplay
@onready var neck_slot_display: EquipmentSlotDisplay = $NeckSlotDisplay
@onready var body_slot_display: EquipmentSlotDisplay = $BodySlotDisplay
@onready var shield_slot_display: EquipmentSlotDisplay = $ShieldSlotDisplay
@onready var weapon_slot_display: EquipmentSlotDisplay = $WeaponSlotDisplay
@onready var waist_slot_display: EquipmentSlotDisplay = $WaistSlotDisplay
@onready var arms_slot_display: EquipmentSlotDisplay = $ArmsSlotDisplay
@onready var hands_slot_display: EquipmentSlotDisplay = $HandsSlotDisplay
@onready var ring_left_slot_display: EquipmentSlotDisplay = $RingLeftSlotDisplay
@onready var ring_right_slot_display: EquipmentSlotDisplay = $RingRightSlotDisplay
@onready var legs_slot_display: EquipmentSlotDisplay = $LegsSlotDisplay
@onready var feet_slot_display: EquipmentSlotDisplay = $FeetSlotDisplay

var slot_mapping: Dictionary[Equipment.EquipmentSlot, EquipmentSlotDisplay] = {}


func _ready() -> void:
  # We wait on setting the mapping until _ready() so our references are valid.
  self.slot_mapping = {
    Equipment.EquipmentSlot.HEAD: self.head_slot_display,
    Equipment.EquipmentSlot.EARRINGS: self.earrings_slot_display,
    Equipment.EquipmentSlot.SHOULDERS: self.shoulders_slot_display,
    Equipment.EquipmentSlot.NECK: self.neck_slot_display,
    Equipment.EquipmentSlot.BODY: self.body_slot_display,
    Equipment.EquipmentSlot.SHIELD: self.shield_slot_display,
    Equipment.EquipmentSlot.WEAPON: self.weapon_slot_display,
    Equipment.EquipmentSlot.WAIST: self.waist_slot_display,
    Equipment.EquipmentSlot.ARMS: self.arms_slot_display,
    Equipment.EquipmentSlot.HANDS: self.hands_slot_display,
    Equipment.EquipmentSlot.RING_LEFT: self.ring_left_slot_display,
    Equipment.EquipmentSlot.RING_RIGHT: self.ring_right_slot_display,
    Equipment.EquipmentSlot.LEGS: self.legs_slot_display,
    Equipment.EquipmentSlot.FEET: self.feet_slot_display
  }

  PlayerManager.create_player_for_test()

  PlayerManager.player.equipment_manager.equipment_equipped.connect(self._on_equip)
  PlayerManager.player.equipment_manager.equipment_removed.connect(self._on_remove)

func _on_equip(equipment: Equipment) -> void:
  self.slot_mapping[equipment.slot].equipment = equipment

func _on_remove(equipment: Equipment) -> void:
  self.slot_mapping[equipment.slot].equipment = null
