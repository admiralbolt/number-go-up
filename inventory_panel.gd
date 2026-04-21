class_name InventoryPanel extends Control

@onready var inventory_display: InventoryDisplay = $InventoryDisplay

func _ready() -> void:
  self.process_mode = Node.PROCESS_MODE_ALWAYS
  self.inventory_display.inventory = PlayerManager.player.inventory
  self.focus_entered.connect(self._on_focus_entered)

func _on_focus_entered() -> void:
  self.inventory_display.is_focused = true
