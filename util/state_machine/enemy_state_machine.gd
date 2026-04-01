class_name EnemyStateMachine extends StateMachine

var enemy: Enemy

func initialize() -> void:
  self.enemy = owner
  super.initialize()