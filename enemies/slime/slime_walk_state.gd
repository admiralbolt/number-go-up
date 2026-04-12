class_name SlimeWalkState extends EnemyState

static var NAME = "walk"

var timer: float = 0.0


func _init() -> void:
  self.state_name = NAME

func on_enter() -> void:
  # Pick a random direction to walk in!
  self.enemy.facing = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

  self.enemy.slime_animator.sprite.hframes = 8
  self.enemy.animation_player.play("EnemyAnimations/walk_%s" % self.enemy.facing_name)

  # Set the timer for a random number of full cycles of the walk animation.
  self.timer = randi_range(3, 5) * self.enemy.animation_player.current_animation_length

func on_exit() -> void:
  self.enemy.animation_player.stop()

func process(delta: float) -> String:
  self.enemy.velocity = self.enemy.facing * self.enemy.derived_statistics.movement_speed.total_value * randf_range(0.2, 0.4)
  self.timer -= delta
  if self.timer <= 0:
    return SlimeIdleState.NAME
  
  return State.NULL_STATE
