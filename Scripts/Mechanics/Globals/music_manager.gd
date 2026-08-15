extends AudioStreamPlayer

func _ready() -> void:
	bus = "Music"

## Plays a file using its UID. Can also fadeout the current song before playing
## the new one.
func play_music(file_uid: String, volume: float = 0, fadeout: bool = false, duration: float = 0) -> void:
	if fadeout:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "volume_db", -60, duration)
		await tween.finished
	
	stream = load(file_uid)
	volume_db = volume
	play()
