class_name SaveDataDisplay extends Button

@export var slot: int = 0

var save_data: SaveData: set = _set_save_data

@onready var empty_label: Label = $Empty

@onready var character_name: Label = $CharacterName
@onready var character_level: Label = $CharacterLevel
@onready var character_class: Label = $CharacterClass
@onready var last_saved: Label = $LastSaved
@onready var play_time: Label = $PlayTime

func _set_save_data(p_save_data: SaveData) -> void:
  save_data = p_save_data

  self.empty_label.visible = self.save_data == null
  self.character_name.visible = self.save_data != null
  self.character_level.visible = self.save_data != null
  self.character_class.visible = self.save_data != null
  self.last_saved.visible = self.save_data != null
  self.play_time.visible = self.save_data != null
  
  if self.save_data == null:
    return

  self.character_name.text = self.save_data.character_name
  self.character_level.text = "Lvl. %s" % self.save_data.player_level
  self.character_class.text = self.save_data.player_class.name
  self.last_saved.text = GodotUtil.format_timestamp(self.save_data.timestamp)
  self.play_time.text = GodotUtil.format_elapsed_time(self.save_data.play_time)


func _ready() -> void:
  self.save_data = SaveManager.load_save_data(self.slot)
  

  
