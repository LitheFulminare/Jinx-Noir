## Salva e carrega as informaçõe do GameState de um arquivo.
extends Node

# TODO 
# Now the timelines are saved in the file when exiting the notebook and loaded again into GameState
# when the alley scene starts. 
# However, something to do with the puzzle_started won't let the player interact with the notebook.
# I have to fix this.
# Also, the notebook state has to be update when loading and the correct lines should be checked.
# Should move some of the TimelineManager logic to the AlleyManager too.

signal game_saved(slot: int)
signal game_loaded(slot: int)

const SAVE_DIR: String = "user://saves/"
const MAX_SLOTS: int = 3

var save_template: String

func _ready() -> void:
	clean_save_folder()

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_P):
		load_game(1)

func save_game(slot: int) -> void:
	var data := GameState.to_dict()
	
	var file := FileAccess.open(_get_path(slot), FileAccess.WRITE)
	if file == null:
		push_error("SaveManager: failed to open save file for writing: " + error_string(FileAccess.get_open_error()))
		return
	
	file.store_var(data)
	file.close()

func load_game(slot: int) -> bool:
	var path := _get_path(slot)
	
	if not FileAccess.file_exists(path):
		push_warning("SaveManager: found no save file at " + path)
		return false
	
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("SaveManager: failed to open save file for reading: " + error_string(FileAccess.get_open_error()))
		return false
	
	var data: Variant = file.get_var()
	
	if data is not Dictionary:
		push_error("SaveManager: save file does not contain a Dictionary.")
		return false
	
	GameState.from_dict(data)
	return true

func get_save_info(slot: int) -> Dictionary:
	var path := _get_path(slot)
	if FileAccess.file_exists(path):
		var file := FileAccess.open(path, FileAccess.READ)
		if file:
			var data: Variant = file.get_var()
			if data is Dictionary:
				return {
					"chapter": data.get("chapter", ""),
					"timestamp": data.get("timestamp", ""),
				}
	
	return {}

func delete_save(slot: int) -> void:
	var path := _get_path(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

func _has_save(slot: int) -> bool:
	return FileAccess.file_exists(_get_path(slot))

func _get_path(slot: int) -> String:
	return SAVE_DIR + "slot_%d.dat" % [slot]

func clean_save_folder() -> void:
	var dir := DirAccess.open(SAVE_DIR)
	
	if dir == null:
		return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir() and not file_name.ends_with(".dat"):
			dir.remove(file_name)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()

## Cria o arquivo de save baseado no save_template.
#func initialize_save_file() -> void:
	#save_template = FileAccess.get_file_as_string(SAVE_TEMPLATE_PATH)
	#var file := FileAccess.open(FILE_PATH, FileAccess.WRITE)
	#file.store_string(save_template)
	#file.close()

## Salva as informações do GameState no arquivo de save. Emite o sinal game_saved ao salvar.
#func save() -> void:
	#var data: Dictionary = GameState.to_dict()
	#var json_string: String = save_template
	#
	## Fazer dessa forma mantém arrays numa linha só e o arquivo fica na ordem que você quiser
	#json_string = json_string.replace("{{CURRENT_SCENE}}", JSON.stringify(data.get("current_scene")))
	#json_string = json_string.replace("{{TIMELINES}}", JSON.stringify(data.get("timelines_finished")))
	#json_string = json_string.replace("{{PUZZLE_ID_&_STATE}}", JSON.stringify(data.get("puzzles_states")))
	#
	#var file := FileAccess.open(FILE_PATH, FileAccess.WRITE)
	#file.store_string(json_string)
	#file.close()
	#
	#game_saved.emit()

## Atualiza as informações do GameState usando o arquivo de save. Emite o sinal game_loaded ao carregar.
#func load_save() -> void:
	#var file := FileAccess.open(FILE_PATH, FileAccess.READ)
	#
	#if !FileAccess.file_exists(FILE_PATH):
		#initialize_save_file()
		#return
	#
	#var json_string: String = file.get_as_text()
	#var data: Dictionary = JSON.parse_string(json_string)
	#
	#GameState.from_dict(data)
	#
	#game_loaded.emit()
