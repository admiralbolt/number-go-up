class_name SkillDisplay extends Control

var skill: Skill

@onready var skill_name_label: Label = $SkillName
@onready var skill_level_label: Label = $SkillLevel
@onready var skill_xp_bar: ProgressBar = $SkillXPBar

@export var display_as_int: bool = false

func _ready() -> void:
  self.focus_entered.connect(self._on_focus_entered)
  self.focus_exited.connect(self._on_focus_exited)

func set_skill(p_skill: Skill) -> void:
  self.skill = p_skill
  self.skill.changed.connect(self.update)
  self.skill_name_label.text = skill.name.capitalize()
  self.update()

func update() -> void:
  self.skill_level_label.text = "Lvl. %d" % self.skill.level
  self.skill_xp_bar.min_value = self.skill.starting_xp_this_level
  self.skill_xp_bar.max_value = self.skill.total_xp_to_next_level
  self.skill_xp_bar.value = self.skill.xp

func _on_focus_entered() -> void:
  self.skill_name_label.add_theme_color_override("font_color", Color8(255, 255, 0))

func _on_focus_exited() -> void:
  self.skill_name_label.remove_theme_color_override("font_color")
