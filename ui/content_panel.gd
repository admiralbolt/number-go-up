class_name ContentPanel extends PanelContainer

signal content_panel_closed

var is_focused: bool = false

func _ready() -> void:
  self.process_mode = Node.PROCESS_MODE_ALWAYS
  self.focus_entered.connect(self._on_focus_entered)
  self.focus_exited.connect(self._on_focus_exited)

func _unhandled_input(event: InputEvent) -> void:
  if not self.is_focused:
    return

  if event.is_action_pressed("ui_cancel"):
    self.is_focused = false
    self.content_panel_closed.emit()
    get_viewport().set_input_as_handled()

func _on_focus_entered() -> void:
  # If our content panel has a child, we want to pass control over to it.
  if self.get_child_count() == 0:
    return

  self.is_focused = true
  self.get_child(0).call_deferred("grab_focus")

func _on_focus_exited() -> void:
  # self.is_focused = false
  return

func change_child(scene: PackedScene) -> void:
  for child in self.get_children():
    self.remove_child(child)
    child.queue_free()

  if scene == null:
    return

  var content_instance: Node = scene.instantiate()
  self.add_child(content_instance)
