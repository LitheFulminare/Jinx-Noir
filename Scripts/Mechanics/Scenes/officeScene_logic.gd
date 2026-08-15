## Gerenciador da cena principal que controla como a cena irá progredir
class_name OfficeSceneManager
extends Node2D

## Para poder guardar qual 'timeline' está em cena atualmente
var cur_timeline: DialogicTimeline
## Para poder sabermos se uma timeline está acontecendo ou não
var timeline_playing:= false 
@onready var interactable_items = $Scene_Elements/Placeholder_BG/Interactable_Items
@onready var audio_player = $Audio_Player
@onready var door: Item = %Door
@onready var phone: Item = %Phone
@onready var phone_audio_player: AudioStreamPlayer2D = %PhoneAudioPlayer

var phone_picked:= false

# Chamado quando o jogo inicia
func _ready() -> void:
	MusicManager.play_music(Constants.SONG_PATHS.Uma_chamada_misteriosa)
	
	Dialogic.text_signal.connect(_handle_dialogic_signals)
	Dialogic.timeline_started.connect(_on_timeline_started) # Fazer com que o sinal de quando a 'timeline' inicia seja conectada com a função deste script
	Dialogic.timeline_ended.connect(_on_timeline_ended) # Fazer com que o sinal de quando a 'timeline' termina seja conectada com a função deste script

	GameState.current_scene = SceneID.OFFICE_SCENE

func _handle_dialogic_signals(method_name: String) -> void:
	if has_method(method_name):
		call(method_name)
		return
	printerr("Tried to call an inexistent method.")

## Função quando o sinal de 'item_collected' dos itens ser ativado
func _on_item_interacted(item: Item) -> void:
	_check_interactions(item)
	Dialogic.start(item.timeline_uid)

## Check everytime an interaction ends to see if the phone should ring
func _check_interactions(item: Item):
	if !item.interacted_once:
		item.interacted_once = true
		Dialogic.VAR.Office.items_interacted += 1
	if Dialogic.VAR.Office.items_interacted == 4:
		await get_tree().create_timer(1.5).timeout
		phone_audio_player.play()
		phone.disabled = false

func phone_call_started() -> void:
	phone_audio_player.stop()

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
