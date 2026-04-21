extends Node

var TEXTURE_MAP: Dictionary[String, Texture2D] = {}

var GENERIC_ICONS_1: SpriteSheetInfo

var DEFAULT_TEXTURE: Texture2D = preload("res://assets/effects/icons/unknown.png")

# We probably want to control when we load all this stuff.
func _init() -> void:
  GENERIC_ICONS_1 = self.make_ss_info("res://assets/items/spritesheets/generic_icons_001.png", 32)

# I'm honestly not entirely sure this is necessary.
func load_texture(path: String) -> Texture2D:
  if TEXTURE_MAP.has(path):
    return TEXTURE_MAP[path]

  var texture: Texture2D = load(path) as Texture2D
  if texture == null:
    push_error("Failed to load texture at path: " + path)
    return DEFAULT_TEXTURE

  TEXTURE_MAP[path] = texture
  return texture


func make_ss_info(p_texture_path: String, p_icon_size: int) -> SpriteSheetInfo:
  var ss_info: SpriteSheetInfo = SpriteSheetInfo.new()
  ss_info.texture_path = p_texture_path
  ss_info.texture = self.load_texture(p_texture_path) as Texture2D
  var size: Vector2 = ss_info.texture.get_size()
  ss_info.icon_size = p_icon_size
  ss_info.hframes = int(size.x / ss_info.icon_size)
  ss_info.vframes = int(size.y / ss_info.icon_size)
  return ss_info
