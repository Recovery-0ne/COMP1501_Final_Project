extends CanvasLayer

var player
var ability_timers: Array#Same order as in UI scene tree

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	ability_timers.append(player.find_child("FireballCooldownTimer"))
	ability_timers.append(player.find_child("FrostCooldownTimer"))
	ability_timers.append(player.find_child("LightningStrikeCooldownTimer"))
	ability_timers.append(player.find_child("DashCooldownTimer"))
	
func _process(delta: float) -> void:
	update_ability_icons()
	
func update_ability_icons():
	for i in range(0, $AbilityIcons.get_child_count()):
		$AbilityIcons.get_child(i).progress_bar.value = (ability_timers[i].time_left)/(ability_timers[i].wait_time)*100
