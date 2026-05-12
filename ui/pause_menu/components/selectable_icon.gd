@tool
class_name SelectableIcon extends Control

@export var texture: Texture2D: set = _set_texture
@export var text: String: set = _set_text

@onready var icon: TextureRect = $PanelContainer/TextureRect
@onready var label: RichTextLabel = $RichTextLabel

static var INACTIVE_COLOR: Color = Color.from_rgba8(85, 85, 85)
static var ACTIVE_COLOR: Color = Color.from_rgba8(255, 255, 255)

func _set_texture(p_texture: Texture2D) -> void:
  texture = p_texture
  if self.icon != null:
    self.icon.texture = texture

func _set_text(p_text: String) -> void:
  text = p_text
  if self.icon != null:
    self.label.text = text

func _ready() -> void:
  if Engine.is_editor_hint():
    return

  if self.text.is_empty():
    self.label.visible = false

  self.focus_mode = Control.FOCUS_NONE

  self.icon.texture = texture
  self.label.text = self.text

  self.icon.modulate = INACTIVE_COLOR
  self.label.modulate = INACTIVE_COLOR

func select() -> void:
  self.icon.modulate = ACTIVE_COLOR
  self.label.modulate = ACTIVE_COLOR

func deselect() -> void:
  self.icon.modulate = INACTIVE_COLOR
  self.label.modulate = INACTIVE_COLOR
