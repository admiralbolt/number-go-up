class_name QuitScreen extends Control

@onready var do_nothing_button: Button = $VBoxContainer/DoNothing
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var quit_text: RichTextLabel = $QuitText

const QUIT_TEXTS: Array[String] = [
  "Take me away from this place.\nI wish to dawdle no longer.",
  "[rainbow]Fuck this[/rainbow]",
  "I do a triple backflip into my Maserati and fly off into the sunset.",
  "Gone for now, but I shall return.",
  "The grind stops.\nI have chores that must be attended to."
]

func _ready() -> void:
  self.focus_entered.connect(self._on_focus_entered)
  self.quit_button.pressed.connect(self._on_quit_pressed)
  self.quit_text.text = QUIT_TEXTS.pick_random()

func _on_focus_entered() -> void:
  self.do_nothing_button.grab_focus()

func _on_quit_pressed() -> void:
  get_tree().quit()
