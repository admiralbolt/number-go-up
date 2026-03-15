class_name Weapon extends Node2D

@onready var animator: WeaponAnimator = $WeaponAnimator
@onready var sprite: Sprite2D = $WeaponSprite
@onready var hit_box: HitBox = $HitBox


func change_weapon(weapon_name: String) -> void:
  sprite.texture = load("res://assets/item/%s.png" % weapon_name)
  

func _ready() -> void:
  hit_box.disable()