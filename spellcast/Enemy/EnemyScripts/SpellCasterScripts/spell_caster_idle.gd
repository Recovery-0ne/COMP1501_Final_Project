extends EnemyState

var saw_player_on_entering_idle:= false

func _enter():
	super()
	saw_player_on_entering_idle = enemy.can_see_target
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
	elif saw_player_on_entering_idle and not enemy.can_see_target:
		state_machine.change_state("look_around")
	
func _exit():
	super()
	saw_player_on_entering_idle = false #Reset the value
	$Timer.stop() #Need to stop the timer because if the enemy transitions to a different state, 
				  #the timer will still be running and will eventually cause a transition to the wander state
	
func _on_timer_timeout() -> void:
	if not enemy.can_see_target:
		state_machine.change_state("wander")
	else:
		$Timer.start()
