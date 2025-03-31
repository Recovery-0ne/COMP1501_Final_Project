extends Node2D

@export var chest_money = 10

func open_chest():
	var ui = get_tree().get_first_node_in_group("In_Game_UI")
	ui.find_child("PlayerMoney").text = "Money: "+str(int(ui.find_child("PlayerMoney").text) + 10)
	ui = get_tree().get_first_node_in_group("Shop_UI")
	ui.find_child("PlayerMoney").text = "Money: "+str(int(ui.find_child("PlayerMoney").text) + 10)
	$ChestImage.hide() 
	$Area2D/CollisionShape2D.disabled = true
