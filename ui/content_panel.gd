class_name ContentPanel extends PanelContainer

signal content_panel_closed

func _unhandled_input(event: InputEvent) -> void:
  if not PauseMenuState.content_focused:
    return

  if event.is_action_pressed("ui_cancel"):
    PauseMenuState.content_focused = false
    self.content_panel_closed.emit()
    get_viewport().set_input_as_handled()

func focus() -> void:
  # If our content panel has a child, we want to pass control over to it.
  if self.get_child_count() == 0:
    return

  self.get_child(0).focus()

func change_child(scene: PackedScene) -> void:
  if scene == null:
    for child in self.get_children():
      self.remove_child(child)
      child.queue_free()
    return

  var content_instance: Node = scene.instantiate()
  if content_instance is not ContentPanel.ContentPanelChild:
    push_error("Content panel scenes must have a root node that extends ContentPanelChild.")
    return

  self.add_child(content_instance)


@abstract
class ContentPanelChild extends Control:

  @abstract func focus() -> void
