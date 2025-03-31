extends Node2D

var player_offset = -34
var player_can_access_shop = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.checkpoint_position = self.global_position
	body.checkpoint_position.y += player_offset
	player_can_access_shop = true
	$ColorRect.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	player_can_access_shop = false
	$ColorRect.visible = false
	
func _process(delta: float) -> void:
	if player_can_access_shop and Input.is_action_just_pressed("open_shop"):
		var UI = get_tree().get_first_node_in_group("Shop_UI")
		UI.set_active_state(!UI.visible)
		$ColorRect.visible = !$ColorRect.visible
