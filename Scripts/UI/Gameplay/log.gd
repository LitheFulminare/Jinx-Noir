class_name Log
extends Control

@export var clues: Array[Label]
@export var clues_container: VBoxContainer

var base_page_height: float
var current_clue_index: int = 0

func _ready() -> void:
	await get_tree().process_frame
	base_page_height = clues_container.size.y

# For debugging porpuses
var cooldown := false
var broom_clue: LogClue = preload("res://Resources/Log/Alley/broom_clue.tres")
func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_0):
		if cooldown:
			return
		add_clue_text(broom_clue)
		cooldown = true
		await get_tree().create_timer(.1).timeout
		cooldown = false

func add_clue_text(clue: LogClue) -> void:
	if current_clue_index != 0:
		add_clue_node()
	
	clues[current_clue_index].text = clue.text
	clues[current_clue_index].show()
	
	current_clue_index += 1

func add_clue_node() -> void:
	var new_clue_node: Label = clues[0].duplicate()
	clues.append(new_clue_node)
	# Need to check if there's enough space here.
	clues_container.add_child(new_clue_node)
	
	await get_tree().physics_frame
	if !can_fit_clue_in_page():
		add_new_page()

func can_fit_clue_in_page() -> bool:
	print("clues_container.size.y: ", clues_container.get_minimum_size().y)
	print("base_page_height: ", base_page_height)
	
	if clues_container.get_minimum_size().y > base_page_height:
		return false
	else:
		print("Can fit new content")
		return true

func add_new_page() -> void:
	print("Adding new page")
