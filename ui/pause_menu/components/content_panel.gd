class_name ContentPanel extends PanelContainer

func _ready() -> void:
  self.process_mode = Node.PROCESS_MODE_ALWAYS
  self.focus_entered.connect(self._on_focus_entered)

func _on_focus_entered() -> void:
  # If our content panel has a child, we want to pass control over to it.
  if self.get_child_count() == 0:
    return

  self.get_child(0).grab_focus()

func change_child(node: Node) -> void:
  for child in self.get_children():
    self.remove_child(child)
    child.queue_free()

  if node == null:
    return

  self.add_child(node)
  self.get_child(0).call_deferred("grab_focus")