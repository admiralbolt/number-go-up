class_name InventorySlotDisplay extends Control

signal focused(slot_data: InventorySlot, index: int)

var slot_data: InventorySlot
var index: int

@onready var sprite: Sprite2D = $Sprite2D
@onready var quantity_label: RichTextLabel = $QuantityLabel

func _ready() -> void:
  self.focus_entered.connect(self._on_focus_entered)
  self.slot_data.item.icon.render(self.sprite)

  if not self.slot_data.item.is_stackable:
    self.quantity_label.text = ""
    self.quantity_label.visible = false
    return

  self.quantity_label.text = "x%s" % self.slot_data.quantity
  return

func _on_focus_entered() -> void:
  self.focused.emit(self.slot_data, self.index)
