class_name SlimeStateMachine extends StateMachine

var enemy: Slime

func initialize2(p_enemy: Slime) -> void:
  self.enemy = p_enemy
  self.initialize()



