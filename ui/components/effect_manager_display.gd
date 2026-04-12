class_name EffectManagerDisplay extends Control

static var EFFECT_DISPLAY_SCENE: PackedScene = preload("res://ui/components/EffectDisplay.tscn")

var effect_to_display: Dictionary[String, EffectDisplay] = {}

@onready var display_container: HBoxContainer = $HBoxContainer

func _ready() -> void:
  if owner is not Entity:
    self.visible = false
    return

  owner.effect_manager.effect_added.connect(_on_effect_added)
  owner.effect_manager.effect_removed.connect(_on_effect_removed)

func _on_effect_added(effect: Effect) -> void:
  var display: EffectDisplay = EFFECT_DISPLAY_SCENE.instantiate()
  display.effect = effect
  self.effect_to_display[effect.get_unique_name()] = display
  self.display_container.add_child(display)

func _on_effect_removed(effect: Effect) -> void:
  var display: EffectDisplay = self.effect_to_display[effect.get_unique_name()]
  self.display_container.remove_child(display)
  display.queue_free()
