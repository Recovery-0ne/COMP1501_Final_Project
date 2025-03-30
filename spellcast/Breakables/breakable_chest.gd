extends Node2D

@export var chest_money = 10

func _ready() -> void:
	pass

func _physics_process(delta):
	if $ChestCast.is_colliding():
		var ui = get_tree().get_first_node_in_group("In_Game_UI")
		ui.find_child("PlayerMoney").text = "Money: "+str(int(ui.find_child("PlayerMoney").text) + 10)
		ui = get_tree().get_first_node_in_group("Shop_UI")
		ui.find_child("PlayerMoney").text = "Money: "+str(int(ui.find_child("PlayerMoney").text) + 10)
		$ChestImage.hide() 
		$ChestCast.enabled = false  

func _process(delta: float) -> void:
	pass
