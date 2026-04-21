class_name SpriteSheetInfo extends Resource

@export var texture_path: String
var texture: Texture2D
@export var hframes: int
@export var vframes: int
@export var icon_size: int

func make_icon(frame: int) -> SpriteSheetIcon:
  return SpriteSheetIcon.new(self, frame)
