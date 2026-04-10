extends CanvasLayer

@onready var tooltip_panel: PanelContainer = $TooltipPanel
@onready var tooltip_content: RichTextLabel = $TooltipPanel/TooltipContent

func _ready() -> void:
  self.process_mode = Node.PROCESS_MODE_ALWAYS
  self.visible = false

func _update_position() -> void:
  self.tooltip_panel.global_position = self.tooltip_panel.get_global_mouse_position() + Vector2(10, 10)

func _process(_delta: float) -> void:
  if not self.visible:
    return

  self._update_position()

func show_tooltip(text: String) -> void:
  self.tooltip_content.text = text
  self.tooltip_panel.reset_size()
  self._update_position()
  self.visible = true

func hide_tooltip() -> void:
  self.visible = false
