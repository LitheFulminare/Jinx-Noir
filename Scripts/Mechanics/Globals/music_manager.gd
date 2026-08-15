extends AudioStreamPlayer

var current_music_uid: String

func _ready() -> void:
	bus = "Music"

## Plays a file using its UID. Can also fadeout the current song before playing
## the new one.
func play_music(file_uid: String, volume: float = 0, fadeout: bool = false, duration: float = 0) -> void:
	if file_uid == current_music_uid:
		return
	
	if fadeout:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "volume_db", -60, duration)
		await tween.finished
	
	current_music_uid = file_uid
	
	stream = load(file_uid)
	volume_db = volume
	play()
