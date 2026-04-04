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
# The full path to the sword shape for this weapon e.g. res://items/weapons/swords/...
# This is a string path instead of the actual SwordShape resource, because
# we only need to load this part when we equip the weapon.
# See the SwordShaping scene for creating this resource.
@export var sword_shape_path: String
# The base rotation of the weapon icon in degrees. The default is 45, which
# means the weapon is pointing up and to the right by default.
@export var base_rotation_degrees: float = 45
# Which attack animation type to use when attacking.
@export var attack_animation_type: AttackAnimationType = AttackAnimationType.SLASH
# Which attack effect type to use when attacking.
@export var attack_animation_effect_type: AttackAnimationEffectType = AttackAnimationEffectType.SLASH
# The minimum damage this weapon can do before bonuses.
@export var min_damage: float = 1.0
# The maximum damage this weapon can do before bonuses.
@export var max_damage: float = 10.0
# The governing skill for this weapon. Determines both which skill will get XP
# and which bonus applies to the damage.
@export var governing_skill: String = Skills.SWORDS

