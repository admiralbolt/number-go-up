class_name EffectDisplay extends Control

const UNKNOWN_EFFECT_ICON: Texture2D = preload("res://assets/effects/icons/unknown.png")

var effect: Effect

@onready var progress_bar: TextureProgressBar = $TextureProgressBar
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
  if self.effect == null:
    self.visible = false
    return

  self.sprite.texture = UNKNOWN_EFFECT_ICON if self.effect.icon == null else self.effect.icon
  self.progress_bar.max_value = self.effect.duration
  self.progress_bar.value = self.effect.timer

  self.effect.changed.connect(self._re_render)

func _re_render() -> void:
  self.progress_bar.max_value = self.effect.duration
  self.progress_bar.value = self.effect.timer
