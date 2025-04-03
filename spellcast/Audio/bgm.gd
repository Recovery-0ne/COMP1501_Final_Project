extends Node

func _ready() -> void:
	play_default_music()

func play_default_music():
	$BossMusic.stop()
	$DefaultMusic.play()
	
func play_boss_music():
	$DefaultMusic.stop()
	$BossMusic.play()
