class_name SlimeAttackState extends EnemyState

static var NAME = "attack"
static var DECELERATION: float = 0.98

func _init() -> void:
  self.state_name = NAME
  self.self_loop = true

func on_enter() -> void:
  self.enemy.animation_player.play("EnemyAnimations/attack_%s" % self.enemy.facing_name)
  self.enemy.animation_player.animation_finished.connect(self._on_animation_finished)

func process(_delta: float) -> String:
  self.enemy.velocity *= DECELERATION
  return State.NULL_STATE

func on_exit() -> void:
  self.enemy.animation_player.stop()
  self.enemy.animation_player.animation_finished.disconnect(self._on_animation_finished)

func _on_animation_finished(_anim_name: String) -> void:
  # After the attack animation finishes we either attack again if the player
  # is close enough, or go back to running at them.
  if self.enemy.global_position.distance_to(PlayerManager.player.global_position) < 25:
    self.state_machine.change_state(SlimeAttackState.NAME)
  else:
    self.state_machine.change_state(SlimeRunState.NAME)