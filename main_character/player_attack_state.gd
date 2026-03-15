class_name PlayerAttackState extends State

static var NAME = "attack"

var direction_name: String = "down"
var attack_timer: float

func _init() -> void:
  self.state_name = NAME

func can_exit(next_state: State) -> bool:
  if attack_timer <= 0:
    return true
  
  return attack_timer <= (PlayerAnimator.ANIMATION_DURATION["attack"] * 0.4) and next_state.state_name in [PlayerRollState.NAME]

func on_enter() -> void:
  self.attack_timer = PlayerAnimator.ANIMATION_DURATION["attack"]
  direction_name = self.state_machine.player.direction_name
  self.state_machine.player.animation_player.play("PlayerAnimations/attack_%s" % direction_name)
  self.state_machine.player.weapon.animator.play("WeaponAnimations/slash_%s" % direction_name)
  self.state_machine.player.weapon.hit_box.enable()

func on_exit() -> void:
  self.state_machine.player.animation_player.stop()
  self.state_machine.player.weapon.animator.stop()
  self.state_machine.player.weapon.animator.weapon.visible = false
  self.state_machine.player.weapon.hit_box.disable()

func process(delta: float) -> String:
  self.attack_timer -= delta
  if self.attack_timer > 0:
    return State.NULL_STATE

  # If the player is still holding a direction, transition to walk, otherwise
  # we want to go to idle.
  if self.state_machine.player.held_direction != Vector2.ZERO:
    return PlayerWalkState.NAME

  return PlayerIdleState.NAME