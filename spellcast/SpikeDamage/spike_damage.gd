extends Area2D

@export var damage: int = 10  # Damage per tick
		
func _physics_process(delta):
	var player_inside = false

	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			player_inside = true
			if $TickTimer.is_stopped():  
				body.take_damage(damage)  
				$TickTimer.start() 
	if !player_inside and !$TickTimer.is_stopped():
		$TickTimer.stop()
		
func _on_Timer_timeout():
	var player = get_tree().get_first_node_in_group("Player")  
	if player:
		player.take_damage(damage)  
