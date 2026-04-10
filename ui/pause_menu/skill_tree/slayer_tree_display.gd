class_name SlayerTreeDisplay extends Control

@onready var skill_node_container: Control = $ScrollContainer/Control
@onready var investment_label: RichTextLabel = $InvestmentLabel

func _ready() -> void:
  if PlayerManager.player.character_class is not SlayerClass:
    push_error("Player's character class is not SlayerClass!")
    return

  for child in self.skill_node_container.get_children():
    if child is not SkillNodeDisplay:
      continue

    child.skill_node = PlayerManager.player.character_class.skill_tree.skill_nodes.get(child.name)

  _update_skill_point_investment_label()
  SignalBus.skill_node_rank_up.connect(self._update_skill_point_investment_label.unbind(2))
  SignalBus.player_level_up.connect(self._update_skill_point_investment_label.unbind(1))

func _update_skill_point_investment_label() -> void:
  var lines: Array[String] = []
  lines.append("Total: [color=orange]%d[/color]" % PlayerManager.player.character_class.total_skill_points)
  if PlayerManager.player.character_class.available_skill_points > 0:
    lines.append("Available: [rainbow]%d[/rainbow]" % PlayerManager.player.character_class.available_skill_points)
  else:
    lines.append("Available: 0")

  self.investment_label.text = "\n".join(lines)


