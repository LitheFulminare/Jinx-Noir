extends Node
## Controla como a sala do ritual irá progredir

#var ritual_room_timeline := preload("res://Timelines/Ritual Room/ritual_room.dtl")
@export var ritual_room_timeline: DialogicTimeline

func _ready() -> void:
	GameState.chapter = 1
	
	Dialogic.text_signal.connect(_handle_dialogic_signals)
	
	Dialogic.start(ritual_room_timeline)

func _handle_dialogic_signals(method_name: String) -> void:
	if has_method(method_name):
		call(method_name)
		return
	printerr("Tried to call an inexistent method.")

func go_to_credits_scene() -> void:
	SceneLoader.load_scene(Constants.SCENE_PATHS.continue)
