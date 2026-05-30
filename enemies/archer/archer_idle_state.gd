class_name ArcherIdleState extends EnemyState

static var NAME = "idle"

var timer: float = 0.0

func _init() -> void:
  self.state_name = NAME

func on_enter() -> void:
  self.enemy.animation_player.play("EnemyAnimations/idle_%s" % self.enemy.facing_name)

  # Set the timer for a random number of full cycles of the walk animation.
  self.timer = randf_range(1.5, 2.5)

func on_exit() -> void:
  self.enemy.animation_player.stop()

func process(delta: float) -> String:
  self.enemy.velocity = Vector2.ZERO
  self.timer -= delta

  # If the player is close-ish, lock on and lock in.
  if self.enemy.global_position.distance_to(PlayerManager.player.global_position) < Archer.LOCK_ON_RANGE:
    return ArcherLockOnState.NAME

  if self.timer > 0:
    return State.NULL_STATE

  return ArcherWalkState.NAME