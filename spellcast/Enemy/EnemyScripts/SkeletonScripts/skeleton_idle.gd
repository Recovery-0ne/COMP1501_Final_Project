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
	if enemy.will_target_player():
		state_machine.change_state("pursue")
	elif not enemy.can_see_target and saw_player_on_entering_idle:
		state_machine.change_state("look_around")
	
func _exit():
	super()
	$Timer.stop() #Need to stop the timer because if the enemy transitions to a different state, 
				  #the timer will still be running and will eventually cause a transition to the wander state
	
func _on_timer_timeout() -> void:
	state_machine.change_state("wander")
