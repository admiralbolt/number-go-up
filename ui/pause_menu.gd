extends CanvasLayer

@onready var button_container: VBoxContainer = %ButtonVBoxContainer

# @export_tool_button("Align Button Style", "Callable") var button_stuff_action = _do_button_stuff

var focus_index: int = 0

func _ready() -> void:
  # Importantly, this needs to be run here because this script *ALSO* runs in
  # the editor.
  self.visible = false
  
  if Engine.is_editor_hint():
    return

  self.process_mode = Node.PROCESS_MODE_ALWAYS

  # Whenever we focus a button, we want to update the focus index.
  var children: Array[Node] = button_container.get_children()
  for i in range(children.size()):
    var button = children[i]
    button.focus_entered.connect(self._on_button_focused.bind(i))

func _on_button_focused(index: int) -> void:
  self.focus_index = index

func open_menu() -> void:
  get_tree().paused = true
  self.visible = true
  SignalBus.pause_menu_opened.emit()

  button_container.get_child(self.focus_index).grab_focus()

func close_menu() -> void:
  get_tree().paused = false
  self.visible = false
  SignalBus.pause_menu_closed.emit()

func _unhandled_input(event: InputEvent) -> void:
  if Engine.is_editor_hint():
    return

  if self.visible and event.is_action_pressed("ui_cancel"):
    self.close_menu()
    get_viewport().set_input_as_handled()
    return

  if event.is_action_pressed("pause"):
    if self.visible:
      self.close_menu()
    else:
      self.open_menu()
    
    get_viewport().set_input_as_handled()




### TOOL SCRIPT STUFF BELOW ###
#=============================#


func _do_button_stuff() -> void:
  # Loop through each button in the buttons, and set stuff.
  for button in button_container.get_children():
    if button is not Button:
      continue

    button.custom_minimum_size = Vector2(50, 28)
    

    
