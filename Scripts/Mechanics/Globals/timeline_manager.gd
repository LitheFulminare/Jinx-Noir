extends Node

var notebook_ref: Notebook
var n_interaction_ref: Item

var correct_lines: Array[int] = []

## Para poder guardar qual 'timeline' está em cena atualmente
var cur_timeline: DialogicTimeline
## Para poder sabermos se uma timeline está acontecendo ou não
var timeline_playing:= false 
## Objetos que devem ser interagidos pelo jogador antes de seguir a timeline
var timelines_finished: Array[String] = []

var alley_manager: AlleyManager

func _ready() -> void:
	SaveManager.game_loaded.connect(on_game_loaded)
	
	Dialogic.timeline_started.connect(_on_timeline_started) # Fazer com que o sinal de quando a 'timeline' inicia seja conectada com a função deste script
	Dialogic.timeline_ended.connect(_on_timeline_ended) # Fazer com que o sinal de quando a 'timeline' termina seja conectada com a função deste script

func on_game_loaded() -> void:
	timelines_finished = GameState.timelines_finished.duplicate()

func increase_tips(last_tip: bool) -> void:
	alley_manager.increase_tips(last_tip)

func _check_complete_timelines(t: String) -> bool:
	return timelines_finished.has(t)

func _get_door_timeline() -> String:
	if !_check_complete_timelines("beco_metal_door_1") and !_check_complete_timelines("beco_notebook_4"):
		return "beco_metal_door_1"
	if _check_complete_timelines("beco_notebook_4") and has_all_correct_lines():
		return "beco_metal_door_2"
	else:
		return "beco_incomplete_scene_3"

func has_all_correct_lines() -> bool:
	return (correct_lines.has(1) &&
			correct_lines.has(2) &&
			correct_lines.has(3) &&
			correct_lines.has(4) &&
			correct_lines.has(5))

## Quando uma timeline começar.
func _on_timeline_started() -> void:
	cur_timeline = Dialogic.current_timeline #  Guarda qual timeline é na variável
	timeline_playing = true # Diz que tem uma timeline ativa
	
## Quando uma timeline terminar.
func _on_timeline_ended() -> void:
	timeline_playing = false # Diz que a timeline não está ativa
	if !timelines_finished.has(cur_timeline.get_identifier()) and cur_timeline.get_identifier() != "beco_start":
		timelines_finished.append(cur_timeline.get_identifier())
		GameState.timelines_finished = timelines_finished.duplicate()
	cur_timeline = null

func clean_text_5() -> void:
	notebook_ref.clean_line_5()
