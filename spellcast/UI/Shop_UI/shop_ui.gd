extends CanvasLayer

var player: Player
var unchosen_abilities:Array
var ability_rows:=4

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	set_shop_abilities()
	set_active_state(false)
	
func set_active_state(active_state:bool):
	#When the shop is open, the rest of the game should be paused
	#Anything that shouldn't be paused will need to have the process mode changed
	get_tree().paused = active_state
	#Set the visibility of all UI
	get_tree().get_first_node_in_group("In_Game_UI").set_active_state(!active_state)
	visible = active_state
	#Activate/Deactivate the dropdowns
	for option in $Ability_Selectors.get_children():
		option.disabled = !active_state
	#Make sure the dropdowns are updated
	update_options()
	print_debug($Ability_Unlocks.get_children()[0].position)
	
func set_shop_abilities():
	var column = 0
	var row = 0
	for i in range(0, player.ability_names.size()):
		var button = load("res://UI/Shop_UI/ability_unlock_button.tscn")
		button = button.instantiate()
		$Ability_Unlocks.add_child(button)
		#Change the name of the button to the name of the ability so that when it's pressed, we can tell what ability is being bought
		button.name = player.ability_names[i]
		#Get the name of the name of the template for the ability icon
		var template_name = player.ability_names[i] + "Cooldown"
		#Get the template node using the name
		var template = get_tree().get_first_node_in_group("In_Game_UI").find_child("Ability_Icon_Templates").find_child(template_name)
		if template != null:
			#Pass the template values so the icon can copy it
			button.set_icon(template.color, template.sprite_transform, template.texture, template.hframes, template.vframes, template.frame)
	
		#Set the position based on the size of the buttons and the current row and column
		button.position = Vector2(column * (button.size.x*1.35), row * (button.size.y*1.35))
		
		#Update row and column for the next ability button
		column += 1
		if (i+1) % ability_rows == 0:
			column = 0
			row += 1
	
func buy_ability(ability_name:String):
	#If an ability is bought, it should be made available and the dropdowns should be updated so that the ability can be chosen
	player.available_abilities.append(ability_name)
	update_options()
	
func update_options():
	#Erase the unchosen_abilities array, so we can build a new one that reflects the current state
	unchosen_abilities.clear()
	#Add a blank option so the player can choose to noot have an ability
	unchosen_abilities.append("")
	#Loop through a range between 0 and the number of abilities the player can choose from
	for i in range(0, player.available_abilities.size()):
		#Get the name of the ability at the current iteration
		var ability_name = player.available_abilities[i]
		#Get the name of the method for the ability at the current iteration
		var ability_method = player.get_ability_method_from_name(ability_name)
		#If the player doesn't have the ability at the current iteration equipped, then it is able to be chosen
		if not player.current_ability_methods.has(ability_method):
			unchosen_abilities.append(player.available_abilities[i])
	#Loop through all of the dropdowns to add the available options to them
	for i in range(0, $Ability_Selectors.get_child_count()):
		#Clear the items from the dropdown before adding the ones from the current state
		$Ability_Selectors.get_children()[i].clear()
		#Add the ability that is currently active to the items array so the selected ability is always displayed in the dropdown
		$Ability_Selectors.get_children()[i].add_item(player.get_nth_current_ability_name_from_method_name(i))
		#Add all of the unchosen_abilities to the items array to allow the player to select them
		for j in unchosen_abilities:
			#If the selected ability is nothing (empty string), don't add it to the items array (continue to the next iteration). This prevents the blank from being shown twice
			if j == "" and $Ability_Selectors.get_children()[i].get_item_text(0) == "":
				continue
			#Add the item at the current iteration from the unchosen abilities to the items array so it can be selected
			$Ability_Selectors.get_children()[i].add_item(j)
	
func _ability_changed(index:int, slot:int):
	#If the selected option is nothing (empty string), then increase the index to match the index in the unchosen_abilities array
	#The matching is needed because the extra blank isn't being displayed, so every index from the display would be 1 less
	if $Ability_Selectors.get_child(slot).get_item_text(0) == "": index += 1
	#Get the index of the selected ability in the available_abilities array
	index = player.available_abilities.find(unchosen_abilities[index-1])
	#Replace the player's old ability with the new one. The slot is which ability is being changed. The index points to which ability to change it to
	player.change_ability(slot,index)
	#Update the option dropdowns to reflect the changed made to which abilities are now available
	update_options()
	#Update the ability icons to reflect the changes made to the equipped abilities
	get_tree().get_first_node_in_group("In_Game_UI").update_ability_icons()
