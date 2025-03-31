extends Node2D

#@onready var player = get_node("/root/AreaTemplate/Player")
var player_offset = -34

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.checkpoint_position = self.global_position
		body.checkpoint_position.y += player_offset
