class_name SaveSlot
extends TextureRect

@export_group("Parameters")
@export var slot: int = 1

@export_group("Nodes")
@export var chapter_label: Label
@export var current_scene_label: Label
@export var last_played_label: Label
@export var save_info: Control
@export var no_save_message: Control

var display_name: String
var last_played_parsed: String
var last_played: Dictionary

var data: Dictionary

func _ready() -> void:
	data = SaveManager.get_save_info(slot)
	if data == {}:
		show_no_save()
	else:
		set_info()

func show_no_save():
	save_info.hide()
	no_save_message.show()

func set_info() -> void:
	var current_scene_uid: String = data.get("current_scene_uid")
	var current_scene: String = Constants.SCENE_PATHS.find_key(current_scene_uid)
	display_name = Constants.SCENE_DISPLAY_NAMES.get(current_scene)
	
	chapter_label.text = "Capítulo " + data.get("Chapter", "0")
	current_scene_label.text = display_name
	last_played_label.text = parse_last_played()

func parse_last_played() -> String:
	last_played = data.get("last_played")
	last_played_parsed = (
		str(last_played.get("day")) +
		"/" +
		str(last_played.get("month")) +
		"/" +
		parse_last_year(last_played.get("year")) +
		"  " +
		parse_time(last_played.get("hour")) +
		":" +
		parse_time(last_played.get("minute"))
		)
	
	return last_played_parsed

func parse_last_year(year: int) -> String:
	var year_string := str(year)
	
	year_string = (
		year_string[year_string.length() - 2] + 
		year_string[year_string.length() - 1]
		)
	
	return year_string

func parse_time(time: int) -> String:
	var time_string := str(time)
	
	if time_string.length() == 1:
		time_string = "0" + time_string
	
	return time_string
