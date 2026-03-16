class_name Weapon extends Node2D

enum AttackAnimationType {
  SLASH
}

enum AttackAnimationEffectType {
  SLASH
}

@export_category("Weapon Info")
# The name of our weapon!
@export var weapon_name: String
# The full path to the icon for this weapon e.g. res://assets/items/red_sword.png
@export var icon_path: String
# The full path to the collision shape for this weapon e.g. res://items/weapons/swords/...
# This is a string path instead of the actual CollisionShape2D resource, because
# we only need to load this part when we equpi the weapon.
@export var collision_shape_path: String
# How much we should scale the entire thing.
@export var render_scale: float
# The base rotation of the weapon icon in degrees. The default is 45, which
# means the weapon is pointing up and to the right by default.
@export var base_rotation_degrees: float = 45
# Offset when rendering the weapon.
@export var position_offset: Vector2 = Vector2.ZERO
# Which attack animation type to use when attacking.
@export var attack_animation_type: AttackAnimationType = AttackAnimationType.SLASH
# Which attack effect type to use when attacking.
@export var attack_animation_effect_type: AttackAnimationEffectType = AttackAnimationEffectType.SLASH





