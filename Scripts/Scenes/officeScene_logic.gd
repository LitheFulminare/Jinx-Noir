## Gerenciador da cena principal que controla como a cena irá progredir
class_name OfficeSceneManager
extends Node2D

## Para poder guardar qual 'timeline' está em cena atualmente
var cur_timeline: DialogicTimeline
## Para poder sabermos se uma timeline está acontecendo ou não
var timeline_playing:= false 
@onready var interactable_items = $Scene_Elements/Placeholder_BG/Interactable_Items
@onready var door: Item = %Door
@onready var phone: Item = %Phone

@export var phone_stream_player: AudioStreamPlayer2D
@export var phone_call_tl: DialogicTimeline

var phone_picked:= false

# Chamado quando o jogo inicia
func _ready() -> void:
	MusicManager.play_music(Constants.SONG_PATHS.Uma_chamada_misteriosa, -6)
	
	Dialogic.text_signal.connect(_handle_dialogic_signals)
	Dialogic.timeline_started.connect(_on_timeline_started) # Fazer com que o sinal de quando a 'timeline' inicia seja conectada com a função deste script
	Dialogic.timeline_ended.connect(_on_timeline_ended) # Fazer com que o sinal de quando a 'timeline' termina seja conectada com a função deste script
	
	GameState.current_scene_uid = Constants.SCENE_PATHS.office
	
	load_progression()
	_check_phone_call(true)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print("DEBUG: going to alley.")
		go_to_alley()
	if Input.is_key_pressed(KEY_P):
		SaveManager.save_game(1)
		print("DEBUG: Game saved.")

func _handle_dialogic_signals(method_name: String) -> void:
	if has_method(method_name):
		call(method_name)
		return
	printerr("Tried to call an inexistent method.")

func load_progression() -> void:
	if TimelineManager.timelines_finished.has(phone_call_tl.get_identifier()):
		door.disabled = false
	else:
		_check_phone_call(true)

## Função quando o sinal de 'item_collected' dos itens ser ativado
func _on_item_interacted(item: Item) -> void:
	_check_interactions(item)
	Dialogic.start(item.timeline_uid)

## Check everytime an interaction ends to see if the phone should ring
func _check_interactions(item: Item):
	if !item.interacted_once:
		item.interacted_once = true
		Dialogic.VAR.Office.items_interacted += 1
	
	_check_phone_call()
	
func _check_phone_call(skip_wait_time := false) -> void:
	if Dialogic.VAR.Office.items_interacted == 4:
		if not skip_wait_time:
			await get_tree().create_timer(1.5).timeout
		phone_stream_player.play()
		phone.disabled = false

func phone_call_started() -> void:
	phone_stream_player.stop()

func phone_call_over() -> void:
	door.disabled = false

## Quando uma timeline começar
func _on_timeline_started() -> void:
	cur_timeline = Dialogic.current_timeline #  Guarda qual timeline é na variável
	timeline_playing = true # Diz que tem uma timeline ativa
	
## Quando uma timeline terminar 
func _on_timeline_ended() -> void:
	timeline_playing = false # Diz que a timeline não está ativa
	cur_timeline = null

func go_to_alley() -> void:
	SceneLoader.load_scene(Constants.SCENE_PATHS.alley)
	MusicManager.play_music(Constants.SONG_PATHS.Jazz_sangrento, -6, true, 2)
