class_name CharacterClassDisplay extends Control

const SKILL_TREES: Dictionary[String, PackedScene] = {
  "Slayer": preload("res://ui/pause_menu/skill_tree/SlayerTreeDisplay.tscn"),
}

func _ready() -> void:
  var skill_tree_scene: PackedScene = SKILL_TREES.get(PlayerManager.player.character_class.name, null)
  if skill_tree_scene == null:
    push_error("No skill tree scene found for character class: %s" % PlayerManager.player.character_class.name)
    return

  self.add_child(skill_tree_scene.instantiate())