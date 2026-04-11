class_name SlimeDeathState extends EnemyState

static var NAME = "death"

func _init() -> void:
  self.state_name = NAME

func init(p_state_machine: StateMachine) -> void:
  super.init(p_state_machine)
  self.enemy.died.connect(self._on_killed)

func on_enter() -> void:
  # enemy.invincible = true
  self.enemy.velocity = Vector2.ZERO
  self.enemy.hurt_box.disable()
  self.enemy.disable_all_hit_boxes()

  self.enemy.hurt_box.set_collision_layer_value(2, false)

  self.enemy.set_collision_layer_value(5, false)
  self.enemy.set_collision_layer_value(9, false)

  self.enemy.animation_player.play("EnemyAnimations/death_%s" % self.enemy.facing_name)
  self.enemy.animation_player.animation_finished.connect(self._on_animation_finished)

func on_exit() -> void:
  self.enemy.animation_player.stop()

func process(_delta: float) -> String:
  return State.NULL_STATE

func _on_killed(_hit_box: HitBox) -> void:
  self.state_machine.change_state(SlimeDeathState.NAME, true)

func _on_animation_finished(_anim_name: String) -> void:
  self.enemy.queue_free()
