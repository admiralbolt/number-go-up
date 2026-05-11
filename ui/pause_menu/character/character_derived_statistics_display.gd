class_name CharacterDerivedStatisticsDisplay extends Control

@onready var derived_statistics_container: VBoxContainer = $HBoxContainer/ScrollContainer/DerivedStatisticListContainer
@onready var derived_statistic_description: RichTextLabel = $HBoxContainer/DerivedStatisticDescription

const DERIVED_STATISTIC_DISPLAY_SCENE: PackedScene = preload("res://ui/components/DerivedStatisticDisplay.tscn")

var derived_statistics: DerivedStatistics

func _ready() -> void:
  self.process_mode = Node.PROCESS_MODE_ALWAYS
  self.derived_statistics = DerivedStatistics.new() if not PlayerManager.player else PlayerManager.player.derived_statistics

  for derived_statistic_name in DerivedStatistics.ALL_DERIVED_STATISTICS:
    # For each of our derived statistics, we want to instantiate it.
    # Compared to attributes, there's just so many of these fuckers, and they
    # are subject to change, so we want to be able to dynamically generate them.
    var new_stat: DerivedStatisticDisplay = DERIVED_STATISTIC_DISPLAY_SCENE.instantiate() as DerivedStatisticDisplay
    new_stat.name = "%sDisplay" % derived_statistic_name.capitalize()
    derived_statistics_container.add_child(new_stat)
    new_stat.set_derived_statistic(self.derived_statistics.get(derived_statistic_name))

  self.focus_entered.connect(self._on_focus_entered)
  self.focus_exited.connect(self._on_focus_exited)

  var children: Array[Node] = derived_statistics_container.get_children()
  for i in range(children.size()):
    var child = children[i]
    child.focus_entered.connect(self._on_derived_statistic_focused.bind(i, child.name))
    child.focus_neighbor_top = children[(i - 1) % children.size()].get_path()
    child.focus_neighbor_left = child.get_path()
    child.focus_neighbor_right = child.get_path()
    child.focus_neighbor_bottom = children[(i + 1) % children.size()].get_path()

func _on_focus_entered() -> void:
  self.derived_statistics_container.get_child(PauseMenuState.derived_statistic_focus_index).grab_focus()

func _on_focus_exited() -> void:
  return

func _on_derived_statistic_focused(index: int, child_name: String) -> void:
  PauseMenuState.derived_statistic_focus_index = index
  self.derived_statistic_description.text = _calculate_description(child_name)

func _calculate_description(child_name: String) -> String:
  for derived_statistic_name in DerivedStatistics.ALL_DERIVED_STATISTICS:
    if child_name == "%sDisplay" % derived_statistic_name.capitalize():
      return _calculate_derived_statistic_description(derived_statistic_name)

  return child_name

func _calculate_derived_statistic_description(derived_statistic_name: String) -> String:
  var derived_statistic: DerivedStatistic = self.derived_statistics.get(derived_statistic_name)
  var builder: Array[String] = []
  builder.append(Descriptions.DERIVED_STATISTIC_DESCRIPTIONS.get(derived_statistic_name, ""))
  builder.append("-----------------\n")
  for line in derived_statistic.compute_total_description():
    builder.append(line)

  builder.append("")
  builder.append("TotalValue: %.2f" % derived_statistic.total_value)

  return "\n".join(builder)
