class_name WeaponRenderer extends Node2D

@onready var animator: WeaponAnimator = $WeaponAnimator
@onready var sprite: Sprite2D = $WeaponSprite
@onready var hit_box: HitBox = $HitBox


func change_weapon(weapon: Weapon) -> void:
  # Set our scale based on the weapon's render scale.
  self.scale = Vector2(weapon.render_scale, weapon.render_scale)

  # Load our sprite.
  sprite.rotation_degrees = 0
  sprite.texture = load(weapon.icon_path)

  # Reload our animator.
  animator.reset()
  animator.initialize(weapon)

  # Load the collision shape for our hit box.
  var shape_with_transform: CollisionWithTransform = load(weapon.collision_shape_path)
  hit_box.reset()
  hit_box.collision_shape.shape = shape_with_transform.collision_shape
  hit_box.position = shape_with_transform.position - (weapon.position_offset / 2)
  hit_box.rotation = shape_with_transform.rotation
  hit_box.scale = shape_with_transform.scale
  hit_box.force_update_transform()
  hit_box.enable()
  hit_box.visible = true

func _ready() -> void:
  # Load our red sword by default, let's see what happens.
  var red_sword = WeaponManager.weapon_registry["red_sword"]
  change_weapon(red_sword)

  # hit_box.disable()