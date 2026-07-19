## Gerenciador da cena do beco que controla como a cena irá progredir
class_name AlleyManager
extends Node2D

var has_trash = false

@onready var interactable_items = $Scene_Elements/Beco_BG/Interactable_Items
@onready var animation_player = $Scene_Elements/AnimationPlayer
@onready var notebook: Notebook = %NotebookPuzzle
## Blocks interaction with items when the notebook is open.
@onready var interaction_blocker: Control = %InteractionBlocker

@export_category("Próxima Cena")
@export var next_scene: PackedScene

var interactions: Array[String] = []

func _ready() -> void:
	SaveManager.game_loaded.connect(on_game_loaded)
	#SaveManager.load_save() # temporary, other script will call the game to load
	
	TimelineManager.alley_manager = self
	
	Dialogic.text_signal.connect(_handle_dialogic_signals)
	Dialogic.timeline_ended.connect(_check_interactions)
	notebook.closed.connect(notebook_closed)
	
	animation_player.play("Fade_In")
	await animation_player.animation_finished
	Dialogic.start("beco_start")
	
	GameState.current_scene = SceneID.ALLEY_SCENE

## Synchronizes notebook puzzle state.
func on_game_loaded() -> void:
	return

func _handle_dialogic_signals(arg: String) -> void:
	match arg:
		"open_notebook":
			open_notebook()

## Called everytime a timeline ends.
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
		Dialogic.start("uid://bmehg03r48ibq")
	else:
		open_notebook()

func open_notebook() -> void:
	interaction_blocker.visible = true
	notebook._open_notebook()

## Allows interactions with the items again. Called when player presses X button on notebook.
func notebook_closed() -> void:
	interaction_blocker.visible = false
	
func go_to_ritual_room() -> void:
	animation_player.play("Fade_Out")
	await animation_player.animation_finished
	TimelineManager.alley_manager = null
	get_tree().change_scene_to_packed(next_scene)
