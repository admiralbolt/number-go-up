class_name SlayerClass extends CharacterClass

func _init() -> void:
  self.name = "Slayer"
  
  self.stat_ordering = StatOrdering.make_from_list([
    Attributes.STRENGTH,
    Attributes.AGILITY,
    Attributes.DEXTERITY,
    Attributes.INTELLIGENCE,
    Attributes.CONSTITUTION,
    Attributes.LUCK,
    Attributes.WISDOM,
    Attributes.SPIRIT,
    Attributes.CHARISMA,
  ])

  self.health_per_level = 5
  self.stamina_per_level = 3
  self.mana_per_level = 2

  self.skill_tree = SkillTree.new()
  self.skill_tree.add_skill(SkillProwess.new())
  self.skill_tree.add_skill(SkillHuntress.new())
