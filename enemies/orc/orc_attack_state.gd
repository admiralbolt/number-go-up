class_name OrcAttackState extends EnemyState

static var NAME = "attack"

var attacks_left: int = 3

func _init() -> void:
  self.state_name = NAME
  self.self_loop = true

func _keep_at_it() -> void:
  self.attacks_left -= 1
  self.enemy.hit_boxes[Orc.SLASH_HIT_BOX].reset()
  self.enemy.animation_player.play("EnemyAnimations/attack_%s" % self.enemy.facing_primary_direction)

func on_enter() -> void:
  self.attacks_left = 3
  self.enemy.hit_boxes[Orc.SLASH_HIT_BOX].enable()
  self.enemy.facing = (PlayerManager.player.global_position - self.enemy.global_position).normalized()
  self.enemy.animation_player.play("EnemyAnimations/attack_%s" % self.enemy.facing_primary_direction)
  self.enemy.animation_player.animation_finished.connect(_keep_at_it.unbind(1))

  self.enemy.physics_manager.knockback_effects.append(PhysicsManager.KnockbackEffect.new(self.enemy.facing, 200, 0.3))

func on_exit() -> void:
  self.enemy.hit_boxes[Orc.SLASH_HIT_BOX].disable()
  self.enemy.animation_player.stop()
  self.enemy.physics_manager.knockback_effects.append(PhysicsManager.KnockbackEffect.new(-1 * self.enemy.facing, 200, 0.3))
  self.enemy.animation_player.animation_finished.disconnect(_keep_at_it)

func process(_delta: float) -> String:
  self.enemy.facing = (PlayerManager.player.global_position - self.enemy.global_position).normalized()
  self.enemy.velocity = Vector2.ZERO

  if self.attacks_left <= 0:
    return OrcStalkState.NAME

  return State.NULL_STATE
