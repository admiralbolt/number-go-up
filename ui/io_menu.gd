class_name IOMenu extends Control

signal button_focused(index: int, button_name: String)
signal button_pressed(index: int, button_name: String)

@onready var button_container: VBoxContainer = $PanelContainer/VBoxContainer

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

  self.focus_entered.connect(self._on_focus_entered)
  self.focus_exited.connect(self._on_focus_exited)

func _on_focus_entered() -> void:
  button_container.get_child(PauseMenuState.io_menu_focus_index).grab_focus()

func _on_focus_exited() -> void:
  return

func _on_button_focused(index: int, button_name: String) -> void:
  PauseMenuState.io_menu_focus_index = index
  button_focused.emit(index, button_name)

func _on_button_pressed(index: int, button_name: String) -> void:
  button_pressed.emit(index, button_name)

  if button_name == "SaveButton":
    SaveManager.save_game()
  elif button_name == "LoadButton":
    SaveManager.load_game()


  elif button_name == "QuitButton":
    get_tree().quit()
