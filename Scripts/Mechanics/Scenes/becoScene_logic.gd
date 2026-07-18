## Gerenciador da cena do beco que controla como a cena irá progredir
class_name AlleyManager
extends Node2D

@export var tip_label: Label
var has_trash = false

@onready var interactable_items = $Scene_Elements/Beco_BG/Interactable_Items
@onready var animation_player = $Scene_Elements/AnimationPlayer
@onready var notebook_ref: Notebook = %NotebookPuzzle
@onready var interaction_blocker: Control = %InteractionBlocker

@export_category("Próxima Cena")
@export var next_scene: PackedScene

var current_item: Item
var current_tips: int = 0

func _ready() -> void:
	SaveManager.game_loaded.connect(on_game_loaded)
	#SaveManager.load_save() # temporary, other script will call the game to load
	
	TimelineManager.alley_manager = self
	
	Dialogic.text_signal.connect(_handle_dialogic_signals)
	notebook_ref.closed.connect(notebook_closed)
	
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

func increase_tips(last_tip: bool) -> void:
	if !current_item.any_tips_left:
		return
	
	current_tips += 1
	if last_tip:
		current_item.any_tips_left = false
		
	tip_label.text = "Pistas: " + str(current_tips) + " /14"
	
## Função quando o sinal de 'item_collected' dos itens ser ativado
func _on_item_interacted(item: Item) -> void:
	current_item = item
	if item.timeline_uid == "" or item.timeline_uid == null:
		return
	Dialogic.start(item.timeline_uid)
	
	#match item.item_type:
		#"notebook":
			#var notebook_timeline: String = TimelineManager._get_notebook_timeline()
			## Não começa uma timeline caso o jogador esteja nas 2 primeiras frases do puzzle
			#if notebook_timeline != "":
				#Dialogic.start(notebook_timeline)

func open_notebook() -> void:
	interaction_blocker.visible = true
	notebook_ref._open_notebook()

## Allows interactions with the items again. Called when player presses X button on notebook.
func notebook_closed() -> void:
	interaction_blocker.visible = false
	
func go_to_ritual_room() -> void:
	animation_player.play("Fade_Out")
	await animation_player.animation_finished
	TimelineManager.alley_manager = null
	get_tree().change_scene_to_packed(next_scene)
