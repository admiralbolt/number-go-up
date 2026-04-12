class_name SlimeAttackState extends EnemyState

static var NAME = "attack"

func _init() -> void:
  self.state_name = NAME
  self.self_loop = true

func on_enter() -> void:
  self.enemy.hit_boxes[Slime.EXPLODE_ATTACK_HITBOX_NAME].enable()
  self.enemy.animation_player.play("EnemyAnimations/attack_%s" % self.enemy.facing_name)

  # Trying a funny thing here, we simulate a slide by applying knockback
  # in the direction we were moving.
  # Turns out this actually works pretty well.
  self.enemy.physics_manager.knockback_effects.append(PhysicsManager.KnockbackEffect.new(self.enemy.facing, 150, 0.3))

func on_exit() -> void:
  self.enemy.hit_boxes[Slime.EXPLODE_ATTACK_HITBOX_NAME].disable()
  self.enemy.animation_player.stop()

func process(_delta: float) -> String:
  var desired_facing: Vector2 = (PlayerManager.player.global_position - self.enemy.global_position).normalized()
  self.enemy.facing = self.enemy.facing.slerp(desired_facing, 0.01)

  self.enemy.velocity = Vector2.ZERO

  if self.enemy.animation_player.is_playing():
    return State.NULL_STATE

  # After the attack animation finishes we either attack again if the player
  # is close enough, or go back to running at them.
  if self.enemy.global_position.distance_to(PlayerManager.player.global_position) < 25:
    self.enemy.animation_player.play("EnemyAnimations/attack_%s" % self.enemy.facing_name)
    return State.NULL_STATE

  return SlimeRunState.NAME

