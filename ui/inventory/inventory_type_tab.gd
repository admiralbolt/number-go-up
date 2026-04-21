class_name InventoryTypeTab extends Control

@export var item_type: Item.ItemType
@export var texture: Texture2D

@onready var icon: TextureRect = $PanelContainer/TextureRect

func _ready() -> void:
  self.icon.texture = texture
  self.icon.modulate = Color.from_rgba8(65, 65, 65)

func select() -> void:
  self.icon.modulate = Color.from_rgba8(255, 255, 255)

func deselect() -> void:
  self.icon.modulate = Color.from_rgba8(125, 125, 125)
