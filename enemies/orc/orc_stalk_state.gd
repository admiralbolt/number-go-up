class_name OrcStalkState extends EnemyState

static var NAME = "stalk"

var timer: float = 0.0
var change_direction_timer: float = 0.0
var current_velocity_sign: int = 0
var current_facing_name: String = ""

func _init() -> void:
  self.state_name = NAME

func _update_facing() -> void:
  self.enemy.facing = (PlayerManager.player.global_position - self.enemy.global_position).normalized()

  if self.enemy.facing_primary_direction == self.current_facing_name:
    return

  self.enemy.animation_player.stop()
  self.current_facing_name = self.enemy.facing_primary_direction
  self.enemy.animation_player.play("EnemyAnimations/walk_%s" % self.current_facing_name)
  

func on_enter() -> void:
  # Wait 2 seconds before leaping.
  self.timer = 1.8
  self.enemy.facing = (PlayerManager.player.global_position - self.enemy.global_position).normalized()
  self.current_facing_name = self.enemy.facing_primary_direction
  self.enemy.animation_player.play("EnemyAnimations/walk_%s" % self.current_facing_name)

func on_exit() -> void:
  self.enemy.animation_player.stop()

func process(delta: float) -> String:
  self.timer -= delta
  self.change_direction_timer -= delta
  self._update_facing()

  # Time has run out, attack!
  if self.timer <= 0:
    return OrcAttackState.NAME

  # Otherwise, keep running, but tune our direction slightly towards the player.
  var desired_facing: Vector2 = (PlayerManager.player.global_position - self.enemy.global_position).normalized()
  self.enemy.facing = self.enemy.facing.slerp(desired_facing, 0.05)
  var distance_to_stalk_distance: float = abs(Orc.STALK_TARGET_DISTANCE - PlayerManager.player.global_position.distance_to(self.enemy.global_position))
  var speed_multiplier: float = 1 - (10 / (10 + distance_to_stalk_distance))
  var velocity_sign: int = -1 if PlayerManager.player.global_position.distance_to(self.enemy.global_position) < Orc.STALK_TARGET_DISTANCE else 1
  if velocity_sign != self.current_velocity_sign and self.change_direction_timer <= 0:
    self.current_velocity_sign = velocity_sign
    self.change_direction_timer = 0.1

  self.enemy.velocity = self.current_velocity_sign * speed_multiplier * self.enemy.facing * self.enemy.derived_statistics.movement_speed.total_value
  return State.NULL_STATE
