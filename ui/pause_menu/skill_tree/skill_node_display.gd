class_name SkillNodeDisplay extends Control

var skill_node: SkillNode: set = _set_skill_node

@onready var skill_icon: Sprite2D = $SkillIcon
@onready var skill_frame: Sprite2D = $SkillFrame
@onready var skill_points_invested_label: Label = $SkillPointsInvested
@onready var red_x_icon: Sprite2D = $RedXIcon

func _set_skill_node(p_skill_node: SkillNode) -> void:
  skill_node = p_skill_node
  skill_icon.texture = load(skill_node.icon_path)
  mouse_entered.connect(self._on_mouse_entered)
  mouse_exited.connect(self._on_mouse_exited)
  gui_input.connect(self._on_gui_input)
  _render()

func _render() -> void:
  # If the skill isn't unlocked, apply the grasycale shader to it.
  self.skill_icon.material = null if self.skill_node.is_unlocked() else MaterialManager.GRAYSCALE

  # If we can't unlock the skill, show the red x icon.
  self.red_x_icon.visible = not self.skill_node.can_unlock()

  self.skill_points_invested_label.text = ""
  if self.skill_node.ranks > 0:
    if self.skill_node.max_ranks > 0:
      self.skill_points_invested_label.text = "%d / %d" % [self.skill_node.ranks, self.skill_node.max_ranks]
    else:
      self.skill_points_invested_label.text = str(self.skill_node.ranks)    

func _on_mouse_entered() -> void:
  var skill_tooltip_text = "[b][color=orange]%s[/color][/b]\n%s" % [skill_node.name, skill_node.dynamic_description()]
  TooltipManager.show_tooltip(skill_tooltip_text)

func _on_mouse_exited() -> void:
  TooltipManager.hide_tooltip()

func _on_gui_input(event: InputEvent) -> void:
  if event is not InputEventMouseButton:
    return

  if event.button_index != MOUSE_BUTTON_LEFT or event.is_pressed():
    return

  if PlayerManager.player.character_class.available_skill_points <= 0:
    return

  if not self.skill_node.is_unlocked() and not self.skill_node.can_unlock():
    return

  if self.skill_node.is_unlocked() and not self.skill_node.can_add_rank():
    return

  self.skill_node.add_rank()
  _render()
  self._on_mouse_entered()