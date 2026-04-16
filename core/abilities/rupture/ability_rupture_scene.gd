class_name AbilityRuptureScene extends Node2D

@onready var hit_box: HitBox = $HitBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func initialize(p_owner: Entity) -> void:
  self.position = p_owner.global_position + p_owner.facing * 45
  self.rotation = p_owner.facing.angle()
  self.hit_box.disable()
  self.hit_box.owning_entity = p_owner
  self.hit_box.knockback = 65

  self.hit_box.damage_ranges = [
    HitBox.DamageRange.make_with_skill(Damage.DamageType.PIERCING, 40.0, 60.0, Skills.SWORDS),
  ]

  var effect: BleedEffect = BleedEffect.new()
  effect.damage_per_second = 8.0
  effect.duration = 8.0
  effect.timer = effect.duration
  effect.owner_entity_id = p_owner.entity_id
  effect.owner = p_owner
  self.hit_box.effects.append(effect)

func play() -> void:
  self.hit_box.enable()
  self.animation_player.animation_finished.connect(_done.unbind(1))
  self.animation_player.play("rupture")

func _done() -> void:
  queue_free()
