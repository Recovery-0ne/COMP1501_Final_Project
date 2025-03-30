extends CanvasLayer

var player:Player
var ability_timers: Array#Same order as in UI scene tree
var dash_timer:Timer

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	for i in range(0,4):
		ability_timers.append(null)
	dash_timer = player.find_child("DashCooldownTimer")
	update_ability_icons()
	
func set_active_state(active_state:bool):
	#Set the visibility
	visible = active_state
	
func _process(delta: float) -> void:
	update_ability_icon_progress()
	
func update_ability_icon_progress():
	#Update the dash progress value to show the player if it is still on cooldown
	#Progress is as a percentage: time_left / total_time * 100%
	$DashIcon/DashCooldown.progress_bar.value = (dash_timer.time_left)/(dash_timer.wait_time)*100
	#Update each of the ability timers
	for i in range(0, $AbilityIcons.get_child_count()):
		#Check if the ability timer is null (no ability in that slot)
		if ability_timers[i] == null: continue #Go to the next iteration
		$AbilityIcons.get_child(i).progress_bar.value = (ability_timers[i].time_left)/(ability_timers[i].wait_time)*100
		
func update_ability_icons():
	#Loop through the ability icons
	for i in range(0,$AbilityIcons.get_child_count()):
		#Check if there isn't an ability assigned to this slot
		if player.current_ability_methods[i] == "":
			#Make the slot empty and set the timer to null because there isn't an ability, so there isn't a timer
			$AbilityIcons.get_child(i).reset_to_default()
			ability_timers[i] = null
		else:
			#Get the name of the name of the template for the ability icon
			var ability_name = player.get_nth_current_ability_name_from_method_name(i) + "Cooldown"
			#Get the template node using the name
			var template = $Ability_Icon_Templates.find_child(ability_name)
			#Check that a template was found
			if template != null:
				#Pass the template values so the icon can copy it
				$AbilityIcons.get_child(i).set_icon(template.color, template.sprite_transform, template.texture, template.hframes, template.vframes, template.frame)
				#Assign the correct timer using the name of the ability
				ability_timers[i] = player.find_child(ability_name+"Timer")
				#Moving the ability to another slot won't reset the timer because the timer time left is never reset, so it will run until it is zero even if the ability is not equipped
