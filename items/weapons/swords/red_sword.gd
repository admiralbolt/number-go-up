class_name RedSword extends Weapon

static var NAME: String = "red_sword"

func _init():
  self.weapon_name = "Red Sword"
  self.icon_path = "res://assets/items/red_sword.png"
  self.collision_shape_path = "res://items/weapons/swords/red_sword_shape.tres"
  self.render_scale = 0.51
  self.base_rotation_degrees = 45
  self.position_offset = Vector2(15, -15)
  self.attack_animation_type = AttackAnimationType.SLASH
  self.attack_animation_effect_type = AttackAnimationEffectType.SLASH
