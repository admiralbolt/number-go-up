class_name SpriteSheetIcon extends Resource

@export var ss_info: SpriteSheetInfo
@export var frame: int

var atlas_texture: AtlasTexture: get = _get_atlas_texture

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

func _get_atlas_texture() -> AtlasTexture:
  if atlas_texture != null:
    return atlas_texture

  if self.ss_info == null:
    return null
  
  var atlas: AtlasTexture = AtlasTexture.new()
  atlas.atlas = self.ss_info.texture
  atlas.region = Rect2(
    Vector2((self.frame % self.ss_info.hframes) * self.ss_info.icon_size, int(float(self.frame) / self.ss_info.hframes) * self.ss_info.icon_size),
    Vector2(self.ss_info.icon_size, self.ss_info.icon_size)
  )
  atlas_texture = atlas
  return atlas_texture

func _to_string() -> String:
  return "SpriteSheetIcon(ss_info=%s, frame=%d)" % [self.ss_info, self.frame]
