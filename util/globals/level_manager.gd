extends Node

var tilemap_bounds: Array[Vector2]
var target_transition: String
var position_offset: Vector2

func _ready() -> void:
  # Make sure this always runs even if the tree is paused.
  self.process_mode = Node.PROCESS_MODE_ALWAYS
  await get_tree().process_frame
  SignalBus.level_loaded.emit()

func load_new_level(level_path: String, p_target_transition: String, p_position_offset: Vector2, force_player_idle: bool = false) -> void:
  print("Loading level: %s, transition_target: %s, offset: %s" % [level_path, p_target_transition, p_position_offset])
  self.target_transition = p_target_transition
  self.position_offset = p_position_offset

  get_tree().paused = true
  await SceneTransition.fade_out()

  if force_player_idle:
    PlayerManager.player.main_player_state_machine.change_state(PlayerIdleState.NAME, true)

  SignalBus.level_load_started.emit()
  await get_tree().process_frame
  get_tree().change_scene_to_file(level_path)
  await SceneTransition.fade_in()

  get_tree().paused = false
  await get_tree().process_frame
  SignalBus.level_loaded.emit()
  

func update_tilemap_bounds(bounds: Array[Vector2]) -> void:
  tilemap_bounds = bounds
  SignalBus.tilemap_bounds_changed.emit(bounds)