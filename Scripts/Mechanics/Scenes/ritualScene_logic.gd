extends Node
## Controla como a sala do ritual irá progredir

var cur_timeline: DialogicTimeline
var timeline_playing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.timeline_started.connect(_on_timeline_started) # Fazer com que o sinal de quando a 'timeline' inicia seja conectada com a função deste script
	Dialogic.timeline_ended.connect(_on_timeline_ended) # Fazer com que o sinal de quando a 'timeline' termina seja conectada com a função deste script
	Dialogic.text_signal.connect(_handle_dialogic_signals)
	
	Dialogic.start("ritualRoom_start")

func _handle_dialogic_signals(method_name: String) -> void:
	if has_method(method_name):
		call(method_name)
		return
	printerr("Tried to call an inexistent method.")

## Quando uma timeline começar
func _on_timeline_started() -> void:
	cur_timeline = Dialogic.current_timeline #  Guarda qual timeline é na variável
	timeline_playing = true # Diz que tem uma timeline ativa
	print("'", cur_timeline.get_identifier(), "'", " começou: ", timeline_playing) # Debug pra indicar qual timeline está tocando e se realmente está tocando
	
## Quando uma timeline terminar 
func _on_timeline_ended() -> void:
	timeline_playing = false # Diz que a timeline não está ativa
	
	cur_timeline = null

func go_to_credits_scene() -> void:
	SceneLoader.load_scene(Constants.SCENE_PATHS.continue)
