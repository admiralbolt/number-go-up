class_name CharacterSkillsDisplay extends Control

@onready var skill_container: VBoxContainer = $HBoxContainer/ScrollContainer/SkillListContainer
@onready var skill_description: RichTextLabel = $HBoxContainer/SkillDescription

const SKILL_DISPLAY_SCENE: PackedScene = preload("res://ui/components/SkillDisplay.tscn")

var skills: Skills

func _ready() -> void:
  self.process_mode = Node.PROCESS_MODE_ALWAYS
  self.skills = Skills.new() if not PlayerManager.player else PlayerManager.player.skills

  for skill_name in Skills.ALL_SKILLS:
    # For each of our skills, we want to instantiate it.
    # Compared to attributes, there's just so many of these fuckers, and they
    # are subject to change, so we want to be able to dynamically generate them.
    var new_skill: SkillDisplay = SKILL_DISPLAY_SCENE.instantiate() as SkillDisplay
    new_skill.name = "%sDisplay" % skill_name.capitalize()
    skill_container.add_child(new_skill)
    new_skill.set_skill(self.skills.get(skill_name))

  self.focus_entered.connect(self._on_focus_entered)
  self.focus_exited.connect(self._on_focus_exited)

  var children: Array[Node] = skill_container.get_children()
  for i in range(children.size()):
    var child = children[i]
    child.focus_entered.connect(self._on_skill_focused.bind(i, child.name))
    child.focus_neighbor_top = children[(i - 1) % children.size()].get_path()
    child.focus_neighbor_left = child.get_path()
    child.focus_neighbor_right = child.get_path()
    child.focus_neighbor_bottom = children[(i + 1) % children.size()].get_path()

func _on_focus_entered() -> void:
  self.skill_container.get_child(PauseMenuState.skill_focus_index).grab_focus()

func _on_focus_exited() -> void:
  return

func _on_skill_focused(index: int, child_name: String) -> void:
  PauseMenuState.skill_focus_index = index
  self.skill_description.text = _calculate_description(child_name)

func _calculate_description(child_name: String) -> String:
  for skill_name in Skills.ALL_SKILLS:
    if child_name == "%sDisplay" % skill_name.capitalize():
      return _calculate_skill_description(skill_name)

  return child_name

func _calculate_skill_description(skill_name: String) -> String:
  var skill: Skill = self.skills.get(skill_name)
  var builder: Array[String] = []
  builder.append(Descriptions.SKILL_DESCRIPTIONS.get(skill_name, ""))
  builder.append("-----------------\n")

  for line in skill.compute_total_description():
    builder.append(line)

  builder.append("TotalValue: %.2f" % skill.total_value)
  return "\n".join(builder)
