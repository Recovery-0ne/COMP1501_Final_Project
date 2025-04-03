extends Area2D

@export var boss: Enemy

func _on_body_entered(body: Node2D) -> void:
	pass

func _on_body_exited(body: Node2D) -> void:
	boss.reset()
