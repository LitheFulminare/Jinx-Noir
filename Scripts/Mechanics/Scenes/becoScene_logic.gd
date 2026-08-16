## Gerenciador da cena do beco que controla como a cena irá progredir
class_name AlleyManager
extends Node2D

var has_trash = false

@onready var interactable_items = $Scene_Elements/Beco_BG/Interactable_Items
@onready var notebook: Notebook = %NotebookPuzzle
## Blocks interaction with items when the notebook is open.
@onready var interaction_blocker: Control = %InteractionBlocker

var interactions: Array[String] = []
var is_introduction_sequence := true

var metal_door_timeline := "uid://dhamrvbgaelw6"
var notebook_no_lines_timeline := "uid://bmehg03r48ibq"

func _ready() -> void:
	MusicManager.play_music(Constants.SONG_PATHS.Jazz_sangrento, -6)
	
	SaveManager.game_loaded.connect(on_game_loaded)
	#SaveManager.load_save() # temporary, other script will call the game to load
	
	TimelineManager.alley_manager = self
	
	Dialogic.text_signal.connect(_handle_dialogic_signals)
	Dialogic.timeline_ended.connect(_check_interactions)
	notebook.closed.connect(notebook_closed)
	
	Dialogic.start("beco_start")
	
	GameState.current_scene = SceneID.ALLEY_SCENE

## Synchronizes notebook puzzle state.
func on_game_loaded() -> void:
	return

func _handle_dialogic_signals(method_name: String) -> void:
	if has_method(method_name):
		call(method_name)
		return
	printerr("Tried to call an inexistent method: ", method_name)

## Called everytime a timeline ends. Checks if a line on the notebook should be cleared.
func _check_interactions() -> void:
	if !Dialogic.VAR.Alley.interacted_with_door:
		return
	
	var clean_texts: Array[int] = []
	
	for text: int in notebook.TEXT_REQUIREMENTS:
		var complete := true
		for interaction: String in notebook.TEXT_REQUIREMENTS.get(text):
			if !Dialogic.VAR.get_variable("Alley.interacted_with_" + interaction):
				complete = false
				break
		if complete:
			clean_texts.append(text)
	if clean_texts.size() > 0:
		notebook._areas_to_clean(clean_texts)
	
## Função quando o sinal de 'item_collected' dos itens ser ativado
func _on_item_interacted(item: Item) -> void:
	if item.item_type != "notebook":
		Dialogic.start(item.timeline_uid)
		return
	
	if !Dialogic.VAR.Alley.Notebook.has_cleaned_a_line:
		Dialogic.start(notebook_no_lines_timeline)
	else:
		open_notebook()

func open_notebook() -> void:
	interaction_blocker.visible = true
	notebook._open_notebook()

## Allows interactions with the items again. Called when player presses X button on notebook.
func notebook_closed() -> void:
	interaction_blocker.visible = false
	if is_introduction_sequence:
		Dialogic.start(metal_door_timeline)
		is_introduction_sequence = false
	
func go_to_ritual_room() -> void:
	TimelineManager.alley_manager = null
	SceneLoader.load_scene(Constants.SCENE_PATHS.ritual_room)
