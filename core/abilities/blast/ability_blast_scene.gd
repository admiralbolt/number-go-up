class_name AbilityBlastScene extends Node2D

@onready var hit_box: HitBox = $HitBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func initialize(p_position: Vector2) -> void:
  self.position = p_position + PlayerManager.player.facing * 40
  self.hit_box.disable()
  self.hit_box.owning_entity = PlayerManager.player
  self.hit_box.knockback = 555

  self.hit_box.damage_ranges = [
    HitBox.DamageRange.make_with_skill(Damage.DamageType.LIGHTNING, 100.0, 120.1, Skills.DESTRUCTION),
  ]

func play() -> void:
  self.hit_box.enable()
  animation_player.animation_finished.connect(_done.unbind(1))
  animation_player.play("explode")

func _done() -> void:
  queue_free()
