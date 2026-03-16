extends Node

var weapon_registry: Dictionary[String, Weapon] = {}

func _ready() -> void:
  weapon_registry["red_sword"] = RedSword.new()


