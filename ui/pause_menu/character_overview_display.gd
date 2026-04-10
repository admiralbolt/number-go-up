class_name CharacterOverviewDisplay extends Control

@onready var vbox: VBoxContainer = $HBoxContainer/VBoxContainer
@onready var column2: VBoxContainer = $HBoxContainer/Column2
@onready var level_label: Label = $HBoxContainer/VBoxContainer/LevelLabel
@onready var class_label: Label = $HBoxContainer/VBoxContainer/ClassLabel
@onready var xp_label: Label = $HBoxContainer/VBoxContainer/XPLabel
@onready var xp_bar: ProgressBar = $HBoxContainer/VBoxContainer/XPLabel/XPBar

func _ready() -> void:
  self.focus_entered.connect(self._on_focus_entered)
  self.focus_exited.connect(self._on_focus_exited)

  # Set neighbors.
  var children: Array[Node] = vbox.get_children()
  for i in range(children.size()):
    var child = children[i]
    child.focus_entered.connect(self._on_item_focused.bind(i, child.name))
    child.focus_exited.connect(self._on_item_exited.bind(i, child.name))
    child.focus_neighbor_top = children[(i - 1) % children.size()].get_path()
    child.focus_neighbor_left = child.get_path()
    child.focus_neighbor_right = child.get_path()
    child.focus_neighbor_bottom = children[(i + 1) % children.size()].get_path()

  # Setup our second column. This will be per-level info about our class. Just
  # a bunch of unfocusable labels.
  var health_label: Label = Label.new()
  health_label.text = "Health per Lvl: %d" % PlayerManager.player.character_class.health_per_level
  health_label.theme = ThemeManager.RICH_TEXT_THEME
  health_label.add_theme_font_size_override("font_size", 12)
  column2.add_child(health_label)

  var mana_label: Label = Label.new()
  mana_label.text = "Mana per Lvl: %d" % PlayerManager.player.character_class.mana_per_level
  mana_label.theme = ThemeManager.RICH_TEXT_THEME
  mana_label.add_theme_font_size_override("font_size", 12)
  column2.add_child(mana_label)

  var stamina_label: Label = Label.new()
  stamina_label.text = "Stamina per Lvl: %d" % PlayerManager.player.character_class.stamina_per_level
  stamina_label.theme = ThemeManager.RICH_TEXT_THEME
  stamina_label.add_theme_font_size_override("font_size", 12)
  column2.add_child(stamina_label)

  var break_label: Label = Label.new()
  break_label.text = "----------\nAttribute Weights\n----------"
  break_label.theme = ThemeManager.RICH_TEXT_THEME
  break_label.add_theme_font_size_override("font_size", 12)
  column2.add_child(break_label)

  # Add labels for each of our attributes.
  for attr_name in Attributes.ALL_ATTRIBUTES:
    var attr_label: Label = Label.new()
    attr_label.theme = ThemeManager.RICH_TEXT_THEME
    attr_label.add_theme_font_size_override("font_size", 12)
    attr_label.text = "%s: %.2f" % [attr_name.capitalize(), PlayerManager.player.character_class.stat_ordering.stat_weights[attr_name]]

    column2.add_child(attr_label)

  _update()
  # Don't need to do any kind of complicated signal handling, just update
  # whenever the pause menu is opened.
  SignalBus.pause_menu_opened.connect(_update)

func _update() -> void:
  self.level_label.text = "Lvl. %d" % PlayerManager.player.level
  self.class_label.text = PlayerManager.player.character_class.name
  self.xp_bar.min_value = PlayerManager.player.starting_xp_this_level
  self.xp_bar.max_value = PlayerManager.player.total_xp_to_next_level
  self.xp_bar.value = PlayerManager.player.xp
  self.xp_label.text = "%d / %d" % [PlayerManager.player.xp, PlayerManager.player.total_xp_to_next_level]

func _on_focus_entered() -> void:
  self.vbox.get_child(PauseMenuState.overview_focus_index).grab_focus()

func _on_focus_exited() -> void:
  return

func _on_item_focused(index: int, _child_name: String) -> void:
  PauseMenuState.overview_focus_index = index
  var child: Node = vbox.get_child(index)
  child.add_theme_color_override("font_color", Color8(255, 255, 0))

func _on_item_exited(index: int, _child_name: String) -> void:
  var child: Node = vbox.get_child(index)
  child.remove_theme_color_override("font_color")
