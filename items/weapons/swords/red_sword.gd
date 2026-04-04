class_name RedSword extends Weapon

static var NAME: String = "red_sword"

func _init():
  self.weapon_name = "Red Sword"
  self.icon_path = "res://assets/items/red_sword.png"
  self.sword_shape_path = "res://items/weapons/swords/red_sword_shape.tres"
  self.base_rotation_degrees = 45
  self.attack_animation_type = AttackAnimationType.SLASH
  self.attack_animation_effect_type = AttackAnimationEffectType.SLASH
  self.min_damage = 11.0
  self.max_damage = 26.0
  self.governing_skill = Skills.SWORDS
