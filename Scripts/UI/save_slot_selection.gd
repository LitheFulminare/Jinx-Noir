extends Control

signal save_slot_selected(slot: int)

func _ready() -> void:
	# Get save data and update the panels.
	
	SaveManager.connect("game_loaded", on_game_loaded)

func _on_save_slot_button_pressed(slot: int) -> void:
	if SaveManager._has_save(slot):
		print("Loading game on slot ", slot)
		SaveManager.load_game(slot)
	else:
		print("Doesn't have save on slot ", slot)

func on_game_loaded() -> void:
	SceneLoader.load_scene(GameState.current_scene_uid)
