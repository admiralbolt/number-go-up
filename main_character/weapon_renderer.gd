class_name WeaponRenderer extends Node2D

@onready var animator: WeaponAnimator = $WeaponAnimator
@onready var sprite_and_shape: Node2D = $SpriteAndShape
@onready var sprite: Sprite2D = $SpriteAndShape/WeaponSprite
@onready var hit_box: HitBox = $SpriteAndShape/HitBox


func change_weapon(weapon: Weapon) -> void:
  var sword_shape: SwordShape = load(weapon.sword_shape_path)

  # Apply parent settings.
  self.sprite_and_shape.scale = sword_shape.parent_scale

  # Apply sprite settings.
  self.sprite.position = sword_shape.sprite_position
  self.sprite.rotation_degrees = 0
  self.sprite.texture = load(weapon.icon_path)
  self.sprite.force_update_transform()

  # Apply collision shape settings.
  self.hit_box.reset()
  self.hit_box.collision_shape.shape = sword_shape.collision_shape
  self.hit_box.position = sword_shape.shape_position
  self.hit_box.rotation = sword_shape.shape_rotation
  self.hit_box.scale = sword_shape.shape_scale

  # Reload animation library.
  self.animator.reset()
  self.animator.initialize(weapon)

  self.sprite_and_shape.visible = false

  self.hit_box.damage_ranges = [
    HitBox.DamageRange.make_with_skill(weapon.damage_type, weapon.min_damage, weapon.max_damage, weapon.governing_skill)
  ]

func _ready() -> void:
  # Load our red sword by default, let's see what happens.
  var red_sword = WeaponManager.weapon_registry["red_sword"]
  change_weapon(red_sword)

  # hit_box.disable()
