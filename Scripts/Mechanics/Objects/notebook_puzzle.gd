class_name Notebook
extends Control

signal closed()

@onready var visibility_player: AnimationPlayer = $Visibility_Player
@onready var notebook_audio: AudioStreamPlayer2D = $Notebook_Audio
@onready var areas_data: Array[TextData] = [load("res://Scenes/Puzzle/Resources/text_1.tres"), load("res://Scenes/Puzzle/Resources/text_2.tres"), load("res://Scenes/Puzzle/Resources/text_3.tres"), load("res://Scenes/Puzzle/Resources/text_4.tres"), load("res://Scenes/Puzzle/Resources/text_5.tres")]
@onready var areas_ref: Array[PuzzleText] = [$Panel/Margins/Grid/Area_1, $Panel/Margins/Grid/Starter_1, $Panel/Margins/Grid/Area_2, $Panel/Margins/Grid/Starter_2, $Panel/Margins/Grid/Area_3, $Panel/Margins/Grid/Starter_3, $Panel/Margins/Grid/Area_4, $Panel/Margins/Grid/Starter_4, $Panel/Margins/Grid/Area_5, $Panel/Margins/Grid/Starter_5]

#var save_path = "user://save"
#var save_name = "puzzleSave.tres"

@export var b_scene: AlleyManager

var first_time_open:= true

const TEXT_REQUIREMENTS := {
	1: ["trash", "broom"],
	2: ["broom", "lamp", "sign"],
	3: ["trash", "sign"],
	4: ["box", "book"]
}

func _ready() -> void:
	TimelineManager.notebook_ref = self
	#_verify_save_path(save_path)
	initialize_texts()
	
func initialize_texts() -> void:
	for text: PuzzleText in areas_ref:
		if text.text_data:
			text.text_data._set_current_sprite(1)
		text.notebook = self
	
#func _verify_save_path(path: String):
	#DirAccess.make_dir_absolute(save_path)

## Checks if all lines are in place.
func check_lines() -> void:
	if !TimelineManager.has_all_correct_lines():
		return
	if TimelineManager.timelines_finished.has("notebook just solved"):
		return
	Dialogic.start("uid://86s08msnla8r") # notebook just solved timeline

func _open_notebook():
	visibility_player.play("open_notebook")

	if first_time_open:
		first_time_open = false

func _areas_to_clean(texts: Array[int]):#text_num: int):
	print("areas_to_clean() called with arg " + str(texts))
	
	var texts_cleaned: Array[int] = []
	for text_num: int in texts:
		if areas_data[text_num - 1].is_censored:
			texts_cleaned.append(text_num)
			Dialogic.VAR.Alley.Notebook.last_line_cleaned = float(text_num)
			areas_data[text_num - 1]._set_current_sprite(2)
		else:
			print(str(text_num) + " is already clean")
		
	if texts_cleaned.size() == 0:
		return
	
	if texts_cleaned.size() == 1:
		Dialogic.start("uid://b7cbwfakv6m8c")
	else:
		Dialogic.start("uid://b5ubuaynhbgq")
	
	#ResourceSaver.save(areas_data[text_num - 1], areas_data[text_num - 1].resource_path)
	#areas_data[text_num - 1] = ResourceLoader.load(areas_data[text_num - 1].resource_path)

func clean_multiple_texts(num1: int, num2: int) -> void:
	if !areas_data[num1 -1].is_censored and !areas_data[num1 - 2].is_censored:
		return
	
	print("Cleaning texts 2 and 3 at the same time")
	areas_data[num1 - 1]._set_current_sprite(2)
	areas_data[num2 - 1]._set_current_sprite(2)
	
	# play sound
	# await
	# play sound
	# start timeline
	
## Chamada depois de deixar as linhas 1 a 4 corretas
func clean_line_5() -> void:
	_areas_to_clean([5])

func save_progression() -> void:
	var notebook_state: Array[int]
	notebook_state.clear() # talvez seja desnecessário
	
	# Guarda o número do texto de cada slot do caderno
	for area: PuzzleText in areas_ref:
		if area.text_data == null:
			notebook_state.append(0)
			continue
		notebook_state.append(area.text_data.text_num)
		
	GameState.puzzles_states.set(PuzzleID.BECO_PUZZLE, notebook_state)
	SaveManager.save()

func _on_close_pressed() -> void:
	closed.emit()
	save_progression()
	visible = false
