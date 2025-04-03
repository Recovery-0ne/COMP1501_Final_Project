extends Area2D

@export var boss: Enemy
@export var music_player: Node

func _on_body_entered(body: Node2D) -> void:
	music_player.play_boss_music()

func _on_body_exited(body: Node2D) -> void:
	boss.reset()
	music_player.play_default_music()
