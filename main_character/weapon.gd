class_name Weapon extends Node2D

@onready var animator: WeaponAnimator = $"WeaponAnimator"
@onready var sprite: Sprite2D = $"WeaponSprite"


func change_weapon(weapon_name: String) -> void:
  sprite.texture = load("res://assets/item/%s.png" % weapon_name)
