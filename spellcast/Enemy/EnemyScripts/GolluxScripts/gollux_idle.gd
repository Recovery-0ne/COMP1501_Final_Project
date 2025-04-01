extends EnemyState

func _enter():
	super()
	$Timer.start()
	
func _update(delta:float):
	super(delta)
	
func _physics_update(delta:float):
	super(delta)
	if enemy.will_target_player():
		state_machine.change_state("pursue")
	
func _exit():
	super()
	$Timer.stop()

func _on_timer_timeout() -> void:
	state_machine.change_state("wander")
