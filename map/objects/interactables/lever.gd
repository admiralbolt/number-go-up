class_name Lever extends InteractableObject

signal state_changed(value: bool)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var state: bool = false

func _ready() -> void:
  self.sprite = $Sprite2D

func activate() -> void:
  if animation_player.is_playing():
    return

  self.state = not self.state
  self.animation_player.play("switch_%s" % ("on" if self.state else "off"))
  self.state_changed.emit(self.state)
