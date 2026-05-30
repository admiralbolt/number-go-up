class_name SlimeIdleState extends EnemyState

static var NAME = "idle"

var timer: float = 0.0

func _init() -> void:
  self.state_name = NAME

func on_enter() -> void:
  self.enemy.animation_player.play("EnemyAnimations/idle_%s" % self.enemy.facing_primary_direction)

  # Set the timer for a random number of full cycles of the walk animation.
  self.timer = randf_range(3.5, 5.5)

func on_exit() -> void:
  self.enemy.animation_player.stop()

func process(delta: float) -> String:
  self.enemy.velocity = Vector2.ZERO  
  self.timer -= delta

  # If the player is close-ish, start running.
  if self.enemy.global_position.distance_to(PlayerManager.player.global_position) < 180:
    return SlimeRunState.NAME

  if self.timer > 0:
    return State.NULL_STATE

  return SlimeWalkState.NAME