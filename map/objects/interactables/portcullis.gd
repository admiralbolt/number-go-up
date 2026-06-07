class_name Portcullis extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func lever_changed(value: bool) -> void:
  self.animation_player.play("open" if value else "close")