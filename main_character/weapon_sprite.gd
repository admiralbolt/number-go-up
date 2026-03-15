class_name WeaponSprite extends Sprite2D

func set_direction(direction_name: String) -> void:
  match direction_name:
    "down":
      self.position = Vector2(6.0, -4.1)
      self.z_index = 1
    "downleft":
      self.position = Vector2(-4, 4)
      self.z_index = 1
    "left":
      self.position = Vector2(-8, 0)
      self.z_index = -1
    "upleft":
      self.position = Vector2(-4, -4)
      self.z_index =-1
    "up":
      self.position = Vector2(0, -8)
      self.z_index = -1
    "upright":
      self.position = Vector2(4, -4)
      self.z_index = -1
    "right":
      self.position = Vector2(8, 0)
      self.z_index = 1
    "downright":
      self.position = Vector2(4, 4)
      self.z_index = 1

