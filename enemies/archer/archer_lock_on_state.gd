class_name ArcherLockOnState extends EnemyState

static var NAME = "lock_on"

var timer: float = 0.0
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
  # Always wait exactly 1 second before entering lock on.
  self.timer = 1.0
  # Face the player!
  self.enemy.facing = (PlayerManager.player.global_position - self.enemy.global_position).normalized()
  self.current_facing_name = self.enemy.facing_name
  self.enemy.animation_player.play("EnemyAnimations/walk_%s" % self.enemy.facing_name)

func on_exit() -> void:
  self.enemy.animation_player.stop()

func process(delta: float) -> String:
  self.timer -= delta

  # Time has run out, fire!
  if self.timer <= 0:
    return ArcherAttackState.NAME

  self._update_facing()

  # Otherwise, keep running, but tune our direction slightly towards the player.
  var desired_facing: Vector2 = (PlayerManager.player.global_position - self.enemy.global_position).normalized()
  self.enemy.facing = self.enemy.facing.slerp(desired_facing, 0.05)
  self.enemy.velocity = -1 * self.enemy.facing * self.enemy.derived_statistics.movement_speed.total_value
  
  return State.NULL_STATE
