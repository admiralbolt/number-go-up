"""Nodes in the skill tree!"""
class_name SkillNode extends Resource

enum SkillNodeType {
  PASSIVE_MODIFIER,
  ACTIVE_SKILL,
}

# The name of the node.
@export var name: String
# Description of the node.
@export var description: String
# The type of the node.
@export var node_type: SkillNodeType
# Current number of stacks for this node. Should be 0 if the node is not unlocked.
@export var stacks: int = 0
# Maximum stacks for this node. If it's not stackable, this should be a 1.
# If it's infinitely stackable, should be -1.
@export var max_stacks: int = 1
# The minimum level required to unlock this node.
@export var required_level: int = 1

func create_modifiers() -> ModifierList:
  return ModifierList.new()

func is_unlocked() -> bool:
  return self.stacks > 0

func can_unlock() -> bool:
  return PlayerManager.player.level >= self.required_level

func can_add_stack() -> bool:
  return self.max_stacks == -1 or self.stacks < self.max_stacks

func add_stack() -> void:
  if not self.can_add_stack():
    return

  for modifier in self.create_modifiers().modifiers:
    PlayerManager.player.modifier_manager.add_modifier(modifier)
  self.stacks += 1

func remove_stack() -> void:
  if self.stacks <= 0:
    return

  for modifier in self.create_modifiers().modifiers:
    PlayerManager.player.modifier_manager.remove_modifier(modifier)
  self.stacks -= 1
  





