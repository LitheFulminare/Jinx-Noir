class_name Log
extends Control

# TODO: Maybe an array of VBoxContainer would be good to manage the pages

## Contains VBoxContainer nodes (pages) as children
@export var margin_container: MarginContainer
@export var clues_container: VBoxContainer

var base_page_height: float
var current_clue_index: int = 0
var current_page_index: int = 0

var pages: Array[VBoxContainer]

const LOG_THEME: Theme = preload("uid://dkna5lalayt3c")

func _ready() -> void:
	await get_tree().process_frame
	base_page_height = clues_container.size.y
	
	pages.append(clues_container)

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
	
	var clue_label: Label = clues_container.get_child(current_clue_index)
	
	clue_label.text = clue.text
	clue_label.show()
	
	current_clue_index += 1

func add_clue_node() -> void:
	var new_clue_node: Label = clues_container.get_child(0).duplicate()
	clues_container.add_child(new_clue_node)
	
	await get_tree().process_frame
	
	if !can_fit_clue_in_page():
		pages.append(create_new_page())
		current_page_index += 1
		
		# Remove label node from the overflowing container and put in new one.
		clues_container.remove_child(new_clue_node)
		pages[current_page_index].add_child(new_clue_node)

func can_fit_clue_in_page() -> bool:
	print("clues_container.size.y: ", clues_container.get_minimum_size().y)
	print("base_page_height: ", base_page_height)
	
	if clues_container.get_minimum_size().y > base_page_height:
		return false
	else:
		print("Can fit new content")
		return true

## Creates a new VBoxContainer node and adds it to the margin container.
func create_new_page() -> VBoxContainer:
	var new_page := VBoxContainer.new()
	margin_container.add_child(new_page)
	
	# Set properties
	# Note: Maybe I should get these properties on the start as store them in a 
	# variable. Or a contant even? Is there such thing as a @onready const ??
	new_page.position = pages[0].position
	new_page.size = pages[0].size
	new_page.theme = LOG_THEME
	
	return new_page

## DEPRECATED.
## Instead of calculating the size of the of the container to see if it
## overflows, the test happens after adding to the container and reparenting
## if necessary. For some reason the total_size calculation returns 1.0 less
## than the size actually is, idk why. I only know it's not the separation.
#func get_predicted_container_size(new_clue_node: Label) -> float:
	#var container_separation = clues_container.get_theme_constant("separation")
	#print("Container separation: ", container_separation)
	#
	#var total_size: float = (
		#clues_container.get_minimum_size().y + 
		#new_clue_node.get_combined_minimum_size().y
		#)
	#
	#print("clues_container.size.y: ", clues_container.get_minimum_size().y)
	#print("Predicted total size: ", total_size)
	#
	#return total_size
