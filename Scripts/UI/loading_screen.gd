class_name LoadingScreen
extends Node

signal loading_screen_ready

@onready var animation_player: AnimationPlayer = %AnimationPlayer

var bypass_fade = false
var previous_sfx_bus_volume: float

func _ready() -> void:
	if !bypass_fade:
		_fade_sfx_bus(false)
	
	await animation_player.animation_finished
	loading_screen_ready.emit()

func _fade_sfx_bus(fade_in: bool) -> void:
	var sfx_bus_index := AudioServer.get_bus_index("SFX")
	var current_sfx_bus_volume := AudioServer.get_bus_volume_linear(sfx_bus_index)
	
	var target_volume: float = 0
	if fade_in:
		target_volume = previous_sfx_bus_volume
	else:
		# Will restore current volume when fading in later on.
		previous_sfx_bus_volume = current_sfx_bus_volume
	
	var fade_duration := animation_player.get_animation("transition").length
	
	var tween := get_tree().create_tween()
	tween.tween_method(
		func(vol: float): AudioServer.set_bus_volume_linear(sfx_bus_index, vol), 
		current_sfx_bus_volume,
		target_volume,
		fade_duration)

func on_progress_changed(_new_value: float) -> void:
	# new_value could be used to update a loading bar, but JN is too light for this
	return

func on_load_finished() -> void:
	if !bypass_fade:
		_fade_sfx_bus(true)
	
	animation_player.play_backwards("transition")
	await animation_player.animation_finished
	queue_free()
