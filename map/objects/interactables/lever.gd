class_name Lever extends InteractableObject

signal state_changed(value: bool)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var state: bool = false

func _ready() -> void:
  self.sprite = $Sprite2D

func activate() -> void:
  if animation_player.is_playing():
    return

  if self.state:
    self.state = false
    self.animation_player.play("switch_off")
    return

  self.state = true
  self.animation_player.play("switch_on")
