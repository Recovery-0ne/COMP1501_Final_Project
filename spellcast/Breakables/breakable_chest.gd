extends Node2D

@export var chest_money = 10

func open_chest():
	var player = get_tree().get_first_node_in_group("Player")
	player.set_money(player.player_money + chest_money)
	$ChestImage.hide() 
	$Area2D/CollisionShape2D.disabled = true
