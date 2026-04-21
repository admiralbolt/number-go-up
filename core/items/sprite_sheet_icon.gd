class_name SpriteSheetIcon extends Resource

@export var ss_info: SpriteSheetInfo
@export var frame: int

func render(sprite: Sprite2D) -> void:
  sprite.texture = self.ss_info.texture
  sprite.hframes = self.ss_info.hframes
  sprite.vframes = self.ss_info.vframes
  sprite.frame = self.frame

func _init(p_ss_info: SpriteSheetInfo, p_frame: int) -> void:
  self.ss_info = p_ss_info
  self.frame = p_frame
