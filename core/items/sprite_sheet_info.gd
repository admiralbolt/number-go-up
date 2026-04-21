class_name SpriteSheetInfo extends Resource

@export var texture_path: String
@export var texture: Texture2D
@export var hframes: int
@export var vframes: int
@export var icon_size: int

func make_icon(frame: int) -> SpriteSheetIcon:
  return SpriteSheetIcon.make(self, frame)

func _to_string() -> String:
  return "SpriteSheetInfo(texture_path=%s, hframes=%d, vframes=%d, icon_size=%d)" % [self.texture_path, self.hframes, self.vframes, self.icon_size]