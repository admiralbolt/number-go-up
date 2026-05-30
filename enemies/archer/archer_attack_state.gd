class_name ArcherAttackState extends EnemyState

static var NAME = "attack"
const SCENE: PackedScene = preload("res://projectiles/ArrowProjectile.tscn")

func _init() -> void:
  self.state_name = NAME
  self.self_loop = true

func on_enter() -> void:
  self.enemy.animation_player.play("EnemyAnimations/attack_%s" % self.enemy.facing_name)
  self.enemy.animation_player.animation_finished.connect(self._fire_arrow)

func on_exit() -> void:
  self.enemy.animation_player.stop()
  self.enemy.animation_player.animation_finished.disconnect(self._fire_arrow)

func process(_delta: float) -> String:
  var desired_facing: Vector2 = (PlayerManager.player.global_position - self.enemy.global_position).normalized()
  self.enemy.facing = self.enemy.facing.slerp(desired_facing, 0.01)

  self.enemy.velocity = Vector2.ZERO

  if self.enemy.animation_player.is_playing():
    return State.NULL_STATE

  # After the attack animation finishes we either attack again if the player
  # is close enough, or go back to running at them.
  if self.enemy.global_position.distance_to(PlayerManager.player.global_position) < Archer.LOCK_ON_RANGE:
    return ArcherLockOnState.NAME

  return ArcherWalkState.NAME

func _fire_arrow(_anim_name: String) -> void:
  var arrow_scene = SCENE.instantiate() as ArrowProjectile
  get_tree().current_scene.add_child(arrow_scene)
  arrow_scene.initialize(self.enemy, (PlayerManager.player.global_position - self.enemy.global_position).normalized(), 220)
