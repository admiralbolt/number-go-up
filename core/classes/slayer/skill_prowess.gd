class_name SkillProwess extends SkillNode

static var NAME: String = "Prowess"

func _init() -> void:
  self.name = NAME
  self.description = "Increase strength and dexterity by 1% per stack."
  self.node_type = SkillNodeType.PASSIVE_MODIFIER
  self.max_ranks = 10

func dynamic_description() -> String:
  return "Increase strength and dexterity by %d%%." % self.ranks

func create_modifiers() -> ModifierList:
  var modifier_list = ModifierList.new()

  var strength_modifier = Modifier.new()
  strength_modifier.source_name = self.name
  strength_modifier.source_type = Modifier.ModifierSource.SKILL_NODE_PASSIVE
  strength_modifier.target_type = Modifier.ModifierTarget.ATTRIBUTE
  strength_modifier.stat_name = Attributes.STRENGTH
  strength_modifier.value = 0.01
  strength_modifier.is_stackable = true
  strength_modifier.modifier_type = Modifier.ModifierType.MULTIPLICATIVE
  strength_modifier.modifier_priority = Modifier.ModifierPriority.APPLY_MULTIPLICATIVE
  strength_modifier.sentiment = Modifier.ModifierSentiment.BUFF

  var dexterity_modifier = Modifier.new()
  dexterity_modifier.source_name = self.name
  dexterity_modifier.source_type = Modifier.ModifierSource.SKILL_NODE_PASSIVE
  dexterity_modifier.target_type = Modifier.ModifierTarget.ATTRIBUTE
  dexterity_modifier.stat_name = Attributes.DEXTERITY
  dexterity_modifier.value = 0.01
  dexterity_modifier.is_stackable = true
  dexterity_modifier.modifier_type = Modifier.ModifierType.MULTIPLICATIVE
  dexterity_modifier.modifier_priority = Modifier.ModifierPriority.APPLY_MULTIPLICATIVE
  dexterity_modifier.sentiment = Modifier.ModifierSentiment.BUFF

  modifier_list.modifiers.append(strength_modifier)
  modifier_list.modifiers.append(dexterity_modifier)

  return modifier_list
