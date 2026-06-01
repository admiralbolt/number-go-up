class_name Enemy extends Entity

var state_machine: EnemyStateMachine
var animation_player: AnimationPlayer

func _ready() -> void:
  super._ready()

  if self.hurt_box == null:
    for child in self.get_children():
      if child is HurtBox:
        self.hurt_box = child
        break

  self.current_health = self.derived_statistics.max_health.total_value
  self.current_stamina = self.derived_statistics.max_stamina.total_value
  self.current_mana = self.derived_statistics.max_mana.total_value

  self.state_machine.enemy = self
  self.state_machine.initialize()