class_name SkillProwess extends SkillNode

const NAME: String = "Prowess"

const PERCENT_INCREASE_PER_RANK: float = 0.01

@export var strength_modifier = Modifier.new()
@export var dexterity_modifier = Modifier.new()

func _init() -> void:
  self.name = NAME
  self.description = "Increase strength and dexterity by 1% per stack."
  self.icon_path = "res://assets/classes/slayer/prowess.png"
  self.node_type = SkillNodeType.PASSIVE_MODIFIER
  self.max_ranks = 10

  self.strength_modifier.source_name = self.name
  self.strength_modifier.source_type = Modifier.ModifierSource.SKILL_NODE_PASSIVE
  self.strength_modifier.target_type = Modifier.ModifierTarget.ATTRIBUTE
  self.strength_modifier.stat_name = Attributes.STRENGTH
  self.strength_modifier.value = 0.01
  self.strength_modifier.modifier_type = Modifier.ModifierType.MULTIPLICATIVE
  self.strength_modifier.modifier_priority = Modifier.ModifierPriority.APPLY_MULTIPLICATIVE
  self.strength_modifier.sentiment = Modifier.ModifierSentiment.BUFF

  self.dexterity_modifier.source_name = self.name
  self.dexterity_modifier.source_type = Modifier.ModifierSource.SKILL_NODE_PASSIVE
  self.dexterity_modifier.target_type = Modifier.ModifierTarget.ATTRIBUTE
  self.dexterity_modifier.stat_name = Attributes.DEXTERITY
  self.dexterity_modifier.value = 0.01
  self.dexterity_modifier.modifier_type = Modifier.ModifierType.MULTIPLICATIVE
  self.dexterity_modifier.modifier_priority = Modifier.ModifierPriority.APPLY_MULTIPLICATIVE
  self.dexterity_modifier.sentiment = Modifier.ModifierSentiment.BUFF

func dynamic_description() -> String:
  var lines: Array[String] = []

  lines.append("Increase strength and dexterity by %d%%." % self.ranks)
  lines.append("-----------")
  lines.append(SKILL_NODE_TYPE_NAMES[self.node_type])
  lines.append("")
  lines.append("Increase strength and dexterity by 1% per rank.")

  return "\n".join(lines)

func add_rank() -> bool:
  if not super.add_rank():
    return false

  # If we just gained this ability, add our modifier to the manager.
  if self.ranks == 1:
    PlayerManager.player.modifier_manager.add_modifier(self.strength_modifier)
    PlayerManager.player.modifier_manager.add_modifier(self.dexterity_modifier)
    return true
  
  # Otherwise we update the values based on the number of ranks.
  self.strength_modifier.value = PERCENT_INCREASE_PER_RANK * self.ranks
  SignalBus.modifier_changed.emit(self.strength_modifier.stat_name)
  self.dexterity_modifier.value = PERCENT_INCREASE_PER_RANK * self.ranks
  SignalBus.modifier_changed.emit(self.dexterity_modifier.stat_name)

  return true

  
