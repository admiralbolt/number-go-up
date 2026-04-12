class_name PlayerAttackState extends PlayerState

static var NAME = "attack"

var direction_name: String = "down"
var attack_timer: float

func _init() -> void:
  self.state_name = NAME
  self.self_loop = true

func can_exit(next_state: State) -> bool:
  if self.attack_timer <= 0:
    return true

  if self.attack_timer >= (PlayerAnimator.ANIMATION_DURATION["attack"] * 0.4):
    return false

  if next_state.state_name == PlayerRollState.NAME:
    return true

  return self.player.weapon_renderer.hit_box.has_hit() and next_state.state_name == PlayerAttackState.NAME

func on_enter() -> void:
  self.attack_timer = PlayerAnimator.ANIMATION_DURATION["attack"]
  direction_name = self.player.direction_name
  self.player.animation_player.play("PlayerAnimations/attack_%s" % direction_name)
  self.player.weapon_renderer.animator.play("WeaponAnimations/slash_%s" % direction_name)
  self.player.weapon_renderer.hit_box.enable()

func on_exit() -> void:
  self.player.animation_player.stop()
  self.player.weapon_renderer.animator.stop()
  self.player.weapon_renderer.sprite_and_shape.visible = false
  self.player.weapon_renderer.hit_box.reset()

func process(delta: float) -> String:
  self.player.velocity = self.player.held_direction.normalized() * self.player.derived_statistics.movement_speed.total_value * 0.5
  
  self.attack_timer -= delta
  if self.attack_timer <= (PlayerAnimator.ANIMATION_DURATION["attack"] * 0.4):
    self.player.weapon_renderer.hit_box.disable()
    self.player.weapon_renderer.sprite_and_shape.visible = false

  if self.attack_timer > 0:
    return State.NULL_STATE

  # If the player is still holding a direction, transition to walk, otherwise
  # we want to go to idle.
  if self.player.held_direction != Vector2.ZERO:
    return PlayerWalkState.NAME

  return PlayerIdleState.NAME
