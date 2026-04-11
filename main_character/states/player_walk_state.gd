class_name PlayerWalkState extends PlayerState

static var NAME = "walk"

var direction_name: String = "down"
var walk_timer: float = 0.05


func _init() -> void:
  self.state_name = NAME

func on_enter() -> void:
  self.walk_timer = 0.05
  direction_name = self.player.direction_name
  self._stop_and_play()

func on_exit() -> void:
  self.player.animation_player.stop()

func _stop_and_play() -> void:
  self.player.animation_player.stop()
  self.player.animation_player.play("PlayerAnimations/walk_%s" % direction_name)

func process(delta: float) -> String:
  if self.player.velocity.length() == 0 and self.walk_timer <= 0:
    return PlayerIdleState.NAME

  var target_vector: Vector2 = self.player.held_direction * self.player.max_speed
  self.player.velocity = PhysicsUtil.apply_acceleration(self.player.velocity, target_vector, self.player.max_speed, delta)
  self.walk_timer -= delta

  if self.player.direction_name != direction_name:
    direction_name = self.player.direction_name
    self._stop_and_play()

  return State.NULL_STATE
