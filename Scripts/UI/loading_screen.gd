class_name LoadingScreen
extends Node

signal loading_screen_ready

@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	fade_sfx_bus()
	
	print("Transition animation started")
	
	await animation_player.animation_finished
	loading_screen_ready.emit()

func fade_sfx_bus() -> void:
	var sfx_bus_index := AudioServer.get_bus_index("SFX")
	var sfx_bus_volume := AudioServer.get_bus_volume_linear(sfx_bus_index)
	
	var fade_duration := animation_player.get_animation("transition").length
	print("fade_duration: ", fade_duration)
	print("sfx_bus_volume: ", sfx_bus_volume)
	
	var tween := get_tree().create_tween()
	tween.tween_method(
		func(vol: float): AudioServer.set_bus_volume_linear(sfx_bus_index, vol), 
		sfx_bus_volume,
		0,
		fade_duration)

func on_progress_changed(_new_value: float) -> void:
	# new_value could be used to update a loading bar, but JN is too light for this
	return

func on_load_finished() -> void:
	print("Animation finished, now playing backwards")
	animation_player.play_backwards("transition")
	await animation_player.animation_finished
	queue_free()
