class_name SlimeAttackState extends EnemyState

static var NAME = "attack"
static var DECELERATION: float = 0.98

func _init() -> void:
  self.state_name = NAME
  self.self_loop = true

func on_enter() -> void:
  self.enemy.animation_player.play("EnemyAnimations/attack_%s" % self.enemy.facing_name)

func on_exit() -> void:
  self.enemy.animation_player.stop()

func process(_delta: float) -> String:
  self.enemy.velocity *= DECELERATION

  if self.enemy.animation_player.is_playing():
    return State.NULL_STATE

  # After the attack animation finishes we either attack again if the player
  # is close enough, or go back to running at them.
  if self.enemy.global_position.distance_to(PlayerManager.player.global_position) < 25:
    self.enemy.animation_player.play("EnemyAnimations/attack_%s" % self.enemy.facing_name)
    return State.NULL_STATE

  return SlimeRunState.NAME

