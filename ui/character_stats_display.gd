class_name CharacterStatsDisplay extends Control

@onready var stats_list: VBoxContainer = $HBoxContainer/StatsListContainer
@onready var stat_description: RichTextLabel = $HBoxContainer/StatDescription

var attributes: Attributes

func _ready() -> void:
  self.process_mode = Node.PROCESS_MODE_ALWAYS
  self.attributes = Attributes.new() if not PlayerManager.player else PlayerManager.player.attributes

  print("STATS DISPLAY\n--------------------")
  PlayerManager.player.attributes.debug_print()
  print("END\n--------")

  self._set_attributes()

  self.focus_entered.connect(self._on_focus_entered)
  self.focus_exited.connect(self._on_focus_exited)


  # Set neighbors.
  var children: Array[Node] = stats_list.get_children()
  for i in range(children.size()):
    var child = children[i]
    child.focus_entered.connect(self._on_attribute_focused.bind(i, child.name))
    child.focus_neighbor_top = children[(i - 1) % children.size()].get_path()
    child.focus_neighbor_left = child.get_path()
    child.focus_neighbor_right = child.get_path()
    child.focus_neighbor_bottom = children[(i + 1) % children.size()].get_path()

func _set_attributes() -> void:
  print("SETTING ATTRIBUTES")
  for attribute_name in Attributes.ALL_ATTRIBUTES:
    var attribute_display: AttributeDisplay = stats_list.get_node("%sDisplay" % attribute_name.capitalize())
    if attribute_display == null:
      continue

    attribute_display.set_attribute(PlayerManager.player.attributes.get(attribute_name))


func _on_focus_entered() -> void:
  self.stats_list.get_child(PauseMenuState.attribute_focus_index).grab_focus()

func _on_focus_exited() -> void:
  return

func _on_attribute_focused(index: int, child_name: String) -> void:
  PauseMenuState.attribute_focus_index = index

  # Calculate the description!
  self.stat_description.text = _calculate_description(child_name)


func _calculate_description(child_name: String) -> String:
  for attribute_name in Attributes.ALL_ATTRIBUTES:
    if child_name == "%sDisplay" % attribute_name.capitalize():
      return _calculate_attribute_description(attribute_name)

  return child_name

func _calculate_attribute_description(attribute_name: String) -> String:
  var attr: Attribute = self.attributes.get(attribute_name)
  var builder: Array[String] = []
  builder.append(Descriptions.ATTRIBUTE_DESCRIPTIONS.get(attribute_name, ""))
  builder.append("-----------------\n")
  builder.append("BaseValue: %s" % str(attr.value))

  for line in attr.compute_total_description():
    builder.append(line)

  builder.append("Total Value: %s" % str(snapped(attr.total_value, 0.01)))
  return "\n".join(builder)
