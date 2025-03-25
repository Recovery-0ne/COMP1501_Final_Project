extends CanvasLayer

var player: Player
var unchosen_abilities:Array

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	set_active_state(false)
	
func set_active_state(active_state:bool):
	get_tree().paused = active_state
	visible = active_state
	for option in $Ability_Selectors.get_children():
		option.disabled = !active_state
	update_options()
	
func buy_ability(ability_name:String):
	player.available_abilities.append(ability_name)
	update_options()
	
func update_options():
	unchosen_abilities.clear()
	unchosen_abilities.append("")
	for i in range(0, player.available_abilities.size()):
		var ability_name = player.available_abilities[i]
		var ability_method = player.get_ability_method_from_name(ability_name)
		if not player.current_ability_methods.has(ability_method):
			unchosen_abilities.append(player.available_abilities[i])
	for option in $Ability_Selectors.get_children():
		option.clear()
		for i in unchosen_abilities:
			option.add_item(i)
	
func _on_visibility_changed() -> void:
	update_options()
	
func _ability_changed(index:int, slot:int):
	index = player.available_abilities.find(unchosen_abilities[index])
	player.change_ability(slot,index)
	update_options()
	get_tree().get_first_node_in_group("In_Game_UI").update_ability_icons()
