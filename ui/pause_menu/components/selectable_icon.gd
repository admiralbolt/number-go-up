class_name SelectableIcon extends Control

signal selected(name: String)

@export var texture: Texture2D
@export var text: String

@onready var icon: TextureRect = $PanelContainer/TextureRect
@onready var label: RichTextLabel = $RichTextLabel

var is_selectable: bool = true
var is_frozen: bool = false

func _ready() -> void:
  if self.text.is_empty():
    self.label.visible = false

  self.icon.texture = texture
  self.icon.modulate = self._get_color()
  self.label.text = self.text
  self.label.modulate = self._get_color()
  self.focus_entered.connect(self.select)
  self.focus_exited.connect(self.deselect)

func _get_color() -> Color:
  if self.is_selectable:
    return Color.from_rgba8(110, 110, 110)

  return Color.from_rgba8(60, 60, 60)

func select() -> void:
  if self.is_frozen:
    return

  self.icon.modulate = Color.from_rgba8(255, 255, 255)
  self.label.modulate = Color.from_rgba8(255, 255, 255)
  self.selected.emit(self.name)

func deselect() -> void:
  if self.is_frozen:
    return

  self.icon.modulate = self._get_color()
  self.label.modulate = self._get_color()
