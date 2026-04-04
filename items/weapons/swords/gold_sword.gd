class_name GoldSword extends Weapon

static var NAME: String = "gold_sword"

func _init():
  self.weapon_name = "Gold Sword"
  self.icon_path = "res://assets/items/gold_sword.png"
  self.sword_shape_path = "res://items/weapons/swords/gold_sword_shape.tres"
  self.base_rotation_degrees = 45
  self.attack_animation_type = AttackAnimationType.SLASH
  self.attack_animation_effect_type = AttackAnimationEffectType.SLASH
  self.min_damage = 11.0
  self.max_damage = 29.0
  self.governing_skill = Skills.SWORDS
