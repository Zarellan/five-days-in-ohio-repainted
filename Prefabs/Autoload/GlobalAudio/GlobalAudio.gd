extends AudioStreamPlayer

var set_on_scene = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func PlayOneShot(audio_path: String, vol_DB = 0.0,pit = 1.0,singleton:bool = false):
	
	var audio = load(audio_path)
	if audio == null:
		push_error("no audio found on "+ audio_path)
		return
	var pl = AudioStreamPlayer.new()
	if !set_on_scene || singleton:
		add_child(pl)
	else:
		get_tree().current_scene.add_child(pl)
	pl.stream = audio
	pl.pitch_scale = pit
	pl.volume_db = vol_DB
	pl.finished.connect(pl.queue_free)
	pl.bus = "Audio"
	pl.play()
	return pl

func SetVolumeMixer(volume):
	var bus_index = AudioServer.get_bus_index("Audio")
	volume = clamp(volume,0,120)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume/100.0))
