extends Node2D


func _ready():
	global_scale = Vector2(1.5, 0.18)

func update_healthbar(health:float):
	$textureprogressbar.value = health
