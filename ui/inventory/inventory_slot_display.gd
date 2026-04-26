class_name InventorySlotDisplay extends Button

signal focused(slot_data: InventorySlot, index: int)
signal used(slot_data: InventorySlot, index: int)

var slot_data: InventorySlot
var index: int

@onready var sprite: Sprite2D = $Sprite2D
@onready var quantity_label: RichTextLabel = $QuantityLabel
@onready var equipped_indiciator: Sprite2D = $EquippedIndicator

func _ready() -> void:
  self.focus_entered.connect(self._on_focus_entered)
  self.pressed.connect(self._use_item)
  self.equipped_indiciator.visible = false
  
  if self.slot_data.item is Equipment:
    self.slot_data.item.equip_changed.connect(self._equip_changed)
    self.equipped_indiciator.visible = self.slot_data.item.is_equipped

  self.slot_data.item.icon.render(self.sprite)

  if not self.slot_data.item.is_stackable:
    self.quantity_label.text = ""
    self.quantity_label.visible = false
    return

  self.quantity_label.text = "x%s" % self.slot_data.quantity
  return

func _on_focus_entered() -> void:
  self.focused.emit(self.slot_data, self.index)

func _use_item() -> void:
  self.used.emit(self.slot_data, self.index)

func _equip_changed() -> void:
  self.equipped_indiciator.visible = self.slot_data.item.is_equipped
