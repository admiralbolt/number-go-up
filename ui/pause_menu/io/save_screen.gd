class_name SaveScreen extends Control

@onready var save_slot_container: VBoxContainer = $ScrollContainer/VBoxContainer

var children: Array[SaveDataDisplay] = []

func _ready() -> void:
  var index: int = 0
  for child in self.save_slot_container.get_children():
    self.children.append(child)
    child.pressed.connect(self._save_slot_pressed.bind(index))
    index += 1

  for i in range(self.children.size()):
    var child: SaveDataDisplay = self.children[i]
    child.focus_neighbor_left = child.get_path()
    child.focus_neighbor_right = child.get_path()
    child.focus_neighbor_top = self.children[(i - 1) % self.children.size()].get_path()
    child.focus_neighbor_bottom = self.children[(i + 1) % self.children.size()].get_path()

  self.focus_entered.connect(func() -> void: self.save_slot_container.get_child(0).grab_focus())

func _save_slot_pressed(index: int = 0) -> void:
  # Probably not necessary, but just in case.
  var child: SaveDataDisplay = self.children[index]
  child.save_data = SaveManager.save_game(child.slot)
  
