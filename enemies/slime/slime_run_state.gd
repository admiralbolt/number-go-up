class_name SlimeRunState extends EnemyState

static var NAME = "run"

var timer: float = 0.0

func _init() -> void:
  self.state_name = NAME

func on_enter() -> void:
  self.timer = randf_range(6.0, 10.0)
  # Run directly towards the player!
  self.enemy.facing = (PlayerManager.player.global_position - self.enemy.global_position).normalized()
  self.enemy.velocity = self.enemy.facing * self.enemy.derived_statistics.movement_speed.total_value * randf_range(0.5, 0.8)

  self.enemy.animation_player.play("EnemyAnimations/run_%s" % self.enemy.facing_name)

func on_exit() -> void:
  self.enemy.animation_player.stop()

func process(delta: float) -> String:
  self.timer -= delta
  # If we get close enough to the player, attack!
  if self.state_machine.enemy.global_position.distance_to(PlayerManager.player.global_position) < 25:
    return SlimeAttackState.NAME

  # If we've been running for a while, give up and idle.
  if self.timer <= 0:
    return SlimeIdleState.NAME

  # Otherwise, keep running, but tune our direction slightly towards the player.
  var desired_facing: Vector2 = (PlayerManager.player.global_position - self.enemy.global_position).normalized()
  self.enemy.facing = self.enemy.facing.slerp(desired_facing, 0.05)
  self.enemy.velocity = self.enemy.facing * self.enemy.derived_statistics.movement_speed.total_value * randf_range(0.5, 0.8)
  
  return State.NULL_STATE
