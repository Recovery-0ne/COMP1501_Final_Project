extends Node

@export var sounds : Dictionary
var tester:AudioStreamPlayer

func play(sound:String):
	var sound_player = find_child(sounds[sound])
	if sound_player.pitch_scale == 1:
		sound_player.pitch_scale = randf_range(0.85, 1.15)
	sound_player.play()
	
func stop(sound:String):
	var sound_player = find_child(sounds[sound])
	sound_player.stop()
