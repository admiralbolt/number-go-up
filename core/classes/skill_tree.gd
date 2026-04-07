class_name SkillTree extends Resource

@export var skill_nodes: Dictionary[String, SkillNode]
@export var edges: Dictionary[String, String]

func add_skill(skill_node: SkillNode) -> void:
  if skill_node.name in self.skill_nodes:
    return

  self.skill_nodes[skill_node.name] = skill_node

