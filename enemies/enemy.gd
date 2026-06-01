class_name Enemy extends Entity

var state_machine: EnemyStateMachine
var animation_player: AnimationPlayer
var sprite: Sprite2D

var flash_tween: Tween

func _ready() -> void:
  super._ready()

  self.current_health = self.derived_statistics.max_health.total_value
  self.current_stamina = self.derived_statistics.max_stamina.total_value
  self.current_mana = self.derived_statistics.max_mana.total_value

  self.state_machine.enemy = self
  self.state_machine.initialize()

  self.hurt_box.on_hit.connect(self._flash_on_hit)

func _flash_on_hit() -> void:
  if self.flash_tween and self.flash_tween.is_valid():
    self.flash_tween.kill()

  self.sprite.modulate = Color.from_rgba8(255, 100, 100)
  self.flash_tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
  self.flash_tween.tween_property(self.sprite, "modulate", Color.from_rgba8(255, 255, 255), 0.6)