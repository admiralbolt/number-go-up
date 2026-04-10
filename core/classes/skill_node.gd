"""Nodes in the skill tree!"""
class_name SkillNode extends Resource

enum SkillNodeType {
  PASSIVE_MODIFIER,
  TRIGGERED_ABILITY,
  ACTIVE_SKILL,
}

static var SKILL_NODE_TYPE_NAMES: Dictionary[SkillNodeType, String] = {
  SkillNodeType.PASSIVE_MODIFIER: "Passive Ability",
  SkillNodeType.TRIGGERED_ABILITY: "Triggered Ability",
  SkillNodeType.ACTIVE_SKILL: "Active Ability",
}

# The name of the node.
@export var name: String
# Description of the node.
@export var description: String
# The icon for the node.
@export var icon_path: String
# The type of the node.
@export var node_type: SkillNodeType
# Current number of ranks for this node. Should be 0 if the node is not unlocked.
@export var ranks: int = 0
# Maximum ranks for this node. If it's not stackable, this should be a 1.
# If it's infinitely stackable, should be -1.
@export var max_ranks: int = 1
# The minimum level required to unlock this node.
@export var required_level: int = 1

func dynamic_description() -> String:
  return self.description

func create_modifiers() -> ModifierList:
  return ModifierList.new()

func is_unlocked() -> bool:
  return self.ranks > 0

func can_unlock() -> bool:
  return PlayerManager.player.level >= self.required_level

func can_add_rank() -> bool:
  return self.max_ranks == -1 or self.ranks < min(self.max_ranks, PlayerManager.player.level - self.required_level + 1)

func add_rank() -> void:
  if not self.can_add_rank():
    return

  for modifier in self.create_modifiers().modifiers:
    PlayerManager.player.modifier_manager.add_modifier(modifier)

  PlayerManager.player.character_class.available_skill_points -= 1
  self.ranks += 1
  SignalBus.skill_node_rank_up.emit(self.name, self.ranks)

func remove_rank() -> void:
  if self.ranks <= 0:
    return

  for modifier in self.create_modifiers().modifiers:
    PlayerManager.player.modifier_manager.remove_modifier(modifier)
  self.ranks -= 1
  SignalBus.skill_node_rank_down.emit(self.name, self.ranks)
