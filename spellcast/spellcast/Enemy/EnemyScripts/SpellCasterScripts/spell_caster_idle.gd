extends EnemyState

func _enter():
	super()
	$Timer.start()
	
func _update(delta: float):
	super(delta)

func _physics_update(delta: float):
	super(delta)
	
	if enemy.can_see_target:
		if enemy.can_attack() and enemy.in_attack_range():
			state_machine.change_state("attack")
		elif not enemy._is_on_ledge() and not enemy._is_facing_wall() and not enemy.in_attack_range():
			state_machine.change_state("pursue")
	elif enemy.position.distance_to(enemy.player.position) < 50 and not enemy.vision.in_vision_cone:
		state_machine.change_state("look_around")
	
func _exit():
	super()
	$Timer.stop() #Need to stop the timer because if the enemy transitions to a different state, 
				  #the timer will still be running and will eventually cause a transition to the wander state
	
func _on_timer_timeout() -> void:
	if not enemy.can_see_target:
		state_machine.change_state("wander")
	else:
		$Timer.start()
