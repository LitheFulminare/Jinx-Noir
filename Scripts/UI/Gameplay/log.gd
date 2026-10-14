class_name Log
extends Control

@export_group("Nodes")
## Contains all the VBoxContainer nodes (pages) as children.
@export var margin_container: MarginContainer
## Contains the references of the VBoxContainer nodes. It's basically a
## organized way of getting the children of margin_container.
@export var pages: Array[VBoxContainer]
@export var previous_button: Button
@export var next_button: Button

## Size of the VBoxContainer that contains the clues.
var page_container_size: Vector2
## Position of the VBoxContainer that contains the clues.
var page_container_position: Vector2
## Controls the assignment of new Label nodes (clues) and the creation of new pages.
var current_page_index: int = 0
## Handles UI logic.
var visible_page_index: int = 0

const LOG_THEME: Theme = preload("uid://dkna5lalayt3c")

func _ready() -> void:
	await get_tree().process_frame
	page_container_size = pages[0].size
	page_container_position = pages[0].position
	
	update_button_visibility()

## For debugging porpuses. Adds a new clue when pressing "0".
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
	var clue_label: Label = await add_clue_node()
	
	clue_label.text = clue.text

func add_clue_node() -> Label:
	var new_clue_node := Label.new()
	pages[current_page_index].add_child(new_clue_node)
	new_clue_node.theme = LOG_THEME
	
	# The size of the Controls node are updated at the end of the process_frame
	await get_tree().process_frame
	
	if is_page_overflowing():
		pages.append(create_new_page())
		update_page_visibility(current_page_index)
		
		pages[current_page_index-1].remove_child(new_clue_node)
		pages[current_page_index].add_child(new_clue_node)
	
	return new_clue_node

func is_page_overflowing() -> bool:
	print("current Page height: ", pages[current_page_index].get_minimum_size().y)
	print("page_container_size.y: ", page_container_size.y)
	
	return pages[current_page_index].get_minimum_size().y > page_container_size.y

## Creates a new VBoxContainer node and adds it to the margin container.
func create_new_page() -> VBoxContainer:
	var new_page := VBoxContainer.new()
	margin_container.add_child(new_page)
	
	new_page.position = page_container_position
	new_page.size = page_container_size
	new_page.theme = LOG_THEME
	
	current_page_index += 1
	
	return new_page

## Shows the page passed as argument and shows/hides both previous and following
## pages (if they exist). This function could be better if it knew the current page
## before changing to the new one, but it doesn't.
func update_page_visibility(_visible_page_index: int) -> void:
	visible_page_index = _visible_page_index
	
	if visible_page_index > 0:
		pages[visible_page_index - 1].hide()
	
	if pages.size() - 1 > visible_page_index:
		pages[visible_page_index + 1].hide()
	
	pages[visible_page_index].show()
	
	update_button_visibility()

## Shows or hides the Next and Previous buttons depending on the current page.
func update_button_visibility() -> void:
	# If it's the last page
	if visible_page_index == pages.size() - 1:
		next_button.modulate.a = 0
		next_button.disabled = true
		if pages.size() > 0: # Size is always bigger than 0?????
			previous_button.modulate.a = 1
			previous_button.disabled = false
	else:
		next_button.modulate.a = 1
		next_button.disabled = false
		
	# If it's the first page
	if visible_page_index == 0:
		previous_button.modulate.a = 0
		previous_button.disabled = true
		if pages.size() > 1:
			next_button.modulate.a = 1
			next_button.disabled = false
	else:
		previous_button.modulate.a = 1
		previous_button.disabled = false

func _on_previous_button_pressed() -> void:
	update_page_visibility(visible_page_index - 1)

func _on_next_button_pressed() -> void:
	update_page_visibility(visible_page_index + 1)

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
