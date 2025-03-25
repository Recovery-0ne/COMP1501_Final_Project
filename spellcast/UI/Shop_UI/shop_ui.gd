extends CanvasLayer

var player: Player

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	update_options()
	
func buy_ability(ability_name:String):
	player.available_abilities.append(ability_name)
	
func update_options():
	for option in $Ability_Selectors.get_children():
		option.clear()
		for i in range(0, player.available_abilities.size()):
			option.add_item(player.available_abilities[i])
	
func _on_visibility_changed() -> void:
	update_options()
	
func _ability_one_changed(index:int):
	player.change_ability(0,index)

func _ability_two_changed(index:int):
	player.change_ability(1,index)
	
func _ability_three_changed(index:int):
	player.change_ability(2,index)
	
func _ability_four_changed(index:int):
	player.change_ability(3,index)
