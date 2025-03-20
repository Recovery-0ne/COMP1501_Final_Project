extends EnemyState

func _enter():
	super()
	$Timer.start()
	
func _update(delta: float):
	super(delta)
	
	if enemy.can_see_target and not enemy._is_on_ledge() and not enemy._is_facing_wall():
		state_machine.change_state("pursue")
	elif enemy.attack_check.is_colliding():
		state_machine.change_state("attack")
	
func _exit():
	super()
	$Timer.stop() #Need to stop the timer because if the enemy transitions to a different state, 
				  #the timer will still be running and will eventually cause a transition to the wander state
	
func _on_timer_timeout() -> void:
	state_machine.change_state("wander")
