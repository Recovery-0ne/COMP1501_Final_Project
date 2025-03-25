extends CanvasLayer

var player:Player
var ability_timers: Array#Same order as in UI scene tree
var dash_timer:Timer

func _ready() -> void:
	self.add_to_group("UI")
	player = get_tree().get_nodes_in_group("Player")[0]
	for i in range(0,4):
		ability_timers.append(null)
	dash_timer = player.find_child("DashCooldownTimer")
	update_ability_icons()
	
func _process(delta: float) -> void:
	update_ability_icon_progress()
	
func update_ability_icon_progress():
	$DashIcon/DashCooldown.progress_bar.value = (dash_timer.time_left)/(dash_timer.wait_time)*100
	for i in range(0, $AbilityIcons.get_child_count()):
		if ability_timers[i] == null: continue
		$AbilityIcons.get_child(i).progress_bar.value = (ability_timers[i].time_left)/(ability_timers[i].wait_time)*100
		
func update_ability_icons():
	for i in range(0,$AbilityIcons.get_child_count()):
		if player.current_ability_methods[i] == "":
			$AbilityIcons.get_child(i).reset_to_default()
		else:
			var ability_name = player.get_nth_current_ability_name_from_method_name(i) + "Cooldown"
			var template = $Ability_Icon_Templates.find_child(ability_name)
			if template != null:
				$AbilityIcons.get_child(i).set_icon(template.color, template.sprite_transform, template.texture, template.hframes, template.vframes, template.frame)
				ability_timers[i] = player.find_child(ability_name+"Timer")
