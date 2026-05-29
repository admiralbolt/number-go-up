class_name InventoryScreen extends Control

var inventory: Inventory: set = _set_inventory
var item_type: Item.ItemType: set = _set_item_type

@onready var coin_label: RichTextLabel = $CoinLabel
@onready var weight_label: RichTextLabel = $WeightLabel
@onready var inventory_display: InventoryDisplay = $InventoryDisplay

func _ready() -> void:
  self.focus_entered.connect(self._on_focus_entered)
  self.coin_label.text = "%s" % (0 if self.inventory == null else self.inventory.coins)
  self.weight_label.text = "%.2f / %.2f" % [self.inventory.total_weight, PlayerManager.player.derived_statistics.carrying_capacity.total_value]
  self.inventory_display.inventory = self.inventory
  self.inventory_display.item_type = self.item_type
  self.inventory_display.render()

func _set_inventory(p_inventory: Inventory) -> void:
  inventory = p_inventory
  self.inventory.updated.connect(self._on_inventory_updated)
  if self.inventory_display != null:
    self.inventory_display.inventory = p_inventory

func _set_item_type(p_item_type: Item.ItemType) -> void:
  item_type = p_item_type
  if self.inventory_display != null:
    self.inventory_display.item_type = p_item_type
    self.inventory_display.render()

func _on_inventory_updated(p_item_type: Item.ItemType) -> void:
  if p_item_type == Item.ItemType.CURRENCY:
    self.coin_label.text = "%s" % (0 if self.inventory == null else self.inventory.coins)
    return

  self.weight_label.text = "%.2f / %.2f" % [self.inventory.total_weight, PlayerManager.player.derived_statistics.carrying_capacity.total_value]
  return

func _on_focus_entered() -> void:
  self.inventory_display.grab_focus()
