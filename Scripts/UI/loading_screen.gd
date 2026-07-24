class_name LoadingScreen
extends Node

signal loading_screen_ready

@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	print("Transition animation started")
	await animation_player.animation_finished
	loading_screen_ready.emit()

func on_progress_changed(_new_value: float) -> void:
	# new_value could be used to update a loading bar, but JN is too light for this
	return

func on_load_finished() -> void:
	print("Animation finished, now playing backwards")
	animation_player.play_backwards("transition")
	await animation_player.animation_finished
	queue_free()
