class_name SpriteSheetIcon extends Resource

@export var ss_info: SpriteSheetInfo
@export var frame: int

static func make(p_ss_info: SpriteSheetInfo, p_frame: int) -> SpriteSheetIcon:
  var icon: SpriteSheetIcon = SpriteSheetIcon.new()
  icon.ss_info = p_ss_info
  icon.frame = p_frame
  return icon

func render(sprite: Sprite2D) -> void:
  sprite.texture = self.ss_info.texture
  sprite.hframes = self.ss_info.hframes
  sprite.vframes = self.ss_info.vframes
  sprite.frame = self.frame

func _to_string() -> String:
  return "SpriteSheetIcon(ss_info=%s, frame=%d)" % [self.ss_info, self.frame]