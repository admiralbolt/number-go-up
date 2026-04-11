class_name SlimeHurtState extends EnemyState

static var NAME = "hurt"

var animation_finished: bool = false
var hit_box_position: Vector2

func _init() -> void:
  self.state_name = NAME

func init(p_state_machine: StateMachine) -> void:
  super.init(p_state_machine)
  self.enemy.damaged.connect(self._on_damaged)

func on_enter() -> void:
  self.animation_finished = false

  self.enemy.animation_player.play("EnemyAnimations/hurt_%s" % self.enemy.facing_name)
  self.enemy.animation_player.animation_finished.connect(self._on_animation_finished)

func on_exit() -> void:
  self.enemy.animation_player.stop()

func process(delta: float) -> String:
  if self.animation_finished:
    return SlimeRunState.NAME

  self.enemy.velocity -= self.enemy.velocity * 7 * delta
  return State.NULL_STATE

func _on_damaged(hit_box: HitBox) -> void:
  self.hit_box_position = hit_box.global_position
  self.state_machine.change_state(SlimeHurtState.NAME, true)

func _on_animation_finished(_anim_name: String) -> void:
  self.animation_finished = true
  self.enemy.animation_player.animation_finished.disconnect(self._on_animation_finished)
