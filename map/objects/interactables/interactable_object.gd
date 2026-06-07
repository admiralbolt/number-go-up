class_name InteractableObject extends StaticBody2D

var sprite: Sprite2D
var hovered: bool = false: set = _set_hovered

func _set_hovered(p_hovered: bool) -> void:
  hovered = p_hovered
  self.sprite.modulate = Color(1.4, 1.4, 1.4) if p_hovered else Color.from_rgba8(255, 255, 255)

# Override this to do stuff.
func activate() -> void:
  return