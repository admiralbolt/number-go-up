class_name ButtonSidebar extends Control

@onready var button_container: VBoxContainer = %ButtonVBoxContainer

signal button_focused(index: int, button_name: String)
signal button_pressed(index: int, button_name: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  self.process_mode = Node.PROCESS_MODE_ALWAYS
  self.focus_mode = Control.FOCUS_ALL

  # Whenever we focus a button, we want to update the focus index.
  var children: Array[Node] = button_container.get_children()
  for i in range(children.size()):
    var button = children[i]
    button.focus_entered.connect(self._on_button_focused.bind(i, button.name))
    button.pressed.connect(self._on_button_pressed.bind(i, button.name))

    # Set our focus'n.
    button.focus_neighbor_top = children[(i - 1) % children.size()].get_path()
    button.focus_neighbor_left = button.get_path()
    button.focus_neighbor_right = button.get_path()
    button.focus_neighbor_bottom = children[(i + 1) % children.size()].get_path()

  button_container.get_child(0).grab_focus()

func focus() -> void:
  button_container.get_child(PauseMenuState.button_sidebar_focus_index).grab_focus()

func _on_button_focused(index: int, button_name: String) -> void:
  if index == PauseMenuState.button_sidebar_focus_index:
    return

  PauseMenuState.button_sidebar_focus_index = index
  button_focused.emit(index, button_name)

func _on_button_pressed(index: int, button_name: String) -> void:
  button_pressed.emit(index, button_name)
