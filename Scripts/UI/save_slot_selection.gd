class_name SaveSlotSelection
extends Control

@export var save_slot: SaveSlot
@export var save_slot_2: SaveSlot
@export var save_slot_3: SaveSlot

@export var overwrite_save_screen: TextureRect

var fade_duration: float = 0.3

enum selection_mode {
	NEW_GAME,
	CONTINUE,
	}

var current_selection_mode := selection_mode.CONTINUE

func _ready() -> void:
	connect_signals()
	
	show_continue_save_slots()

func connect_signals() -> void:
	SaveManager.game_loaded.connect(on_game_loaded)
	
	save_slot.save_selected.connect(_on_save_slot_button_pressed)
	save_slot_2.save_selected.connect(_on_save_slot_button_pressed)
	save_slot_3.save_selected.connect(_on_save_slot_button_pressed)
	
	save_slot.new_game_button_pressed.connect(_new_game_button_pressed)
	save_slot_2.new_game_button_pressed.connect(_new_game_button_pressed)
	save_slot_3.new_game_button_pressed.connect(_new_game_button_pressed)

func show_menu() -> void:
	# the first time it appears it's not transparent, so it need this
	modulate = Color.TRANSPARENT
	show()
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, fade_duration)

func hide_menu() -> void:
	var tween := get_tree().create_tween()
	await tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_duration).finished
	hide()

func _on_save_slot_button_pressed(slot: int) -> void:
	if SaveManager._has_save(slot):
		print("Loading game on slot ", slot)
		SaveManager.current_save_slot = slot
		SaveManager.load_game(slot)
	else:
		print("Doesn't have save on slot ", slot)

func _new_game_button_pressed(slot: int) -> void:
	SaveManager.current_save_slot = slot
	
	if SaveManager._has_save(slot):
		overwrite_save_screen.show()
	else:
		start_game()

func start_game() -> void:
	SceneLoader.load_scene(Constants.SCENE_PATHS.chapter_1_intro)
	MusicManager.play_music(
		Constants.SONG_PATHS.Uma_chamada_misteriosa, # Song name
		-6, # Volume
		true, # Fade out
		2 # Fade out duration
		)

func on_game_loaded() -> void:
	SceneLoader.load_scene(GameState.current_scene_uid)

func set_selection_mode(mode: selection_mode) -> void:
	current_selection_mode = mode
	
	match current_selection_mode:
		selection_mode.NEW_GAME:
			show_new_game_save_slots()
		selection_mode.CONTINUE:
			show_continue_save_slots()

func show_continue_save_slots() -> void:
	save_slot.show_continue_option()
	save_slot_2.show_continue_option()
	save_slot_3.show_continue_option()

func show_new_game_save_slots() -> void:
	save_slot.show_new_game_option()
	save_slot_2.show_new_game_option()
	save_slot_3.show_new_game_option()

func _on_leave_button_pressed() -> void:
	hide_menu()

func _on_confirm_button_pressed() -> void:
	start_game()

func _on_return_button_pressed() -> void:
	overwrite_save_screen.hide()
