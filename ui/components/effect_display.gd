class_name EffectDisplay extends Control

const UNKNOWN_EFFECT_ICON: Texture2D = preload("res://assets/effects/icons/unknown.png")

var effect: Effect

@onready var progress_bar: ColorRect = $RadialProgressBar
@onready var sprite: Sprite2D = $Sprite2D
@onready var stack_count_label: RichTextLabel = $StackCount

func _ready() -> void:
  if self.effect == null:
    self.visible = false
    return

  self.sprite.texture = UNKNOWN_EFFECT_ICON if self.effect.icon == null else self.effect.icon

  self.effect.changed.connect(self._re_render)
  self._re_render()

func _re_render() -> void:
  self.progress_bar.material.set_shader_parameter("value", self.effect.timer / self.effect.duration)
  self.stack_count_label.text = "x%d" % self.effect.stack_count if self.effect.is_stackable else ""
