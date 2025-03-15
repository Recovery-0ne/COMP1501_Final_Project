extends EnemyState

func _enter():
	super()
	$Timer.start()
	
func _update(delta: float):
	super(delta)
	
func _exit():
	super()
	
func _on_timer_timeout() -> void:
	state_machine.change_state(enemy.states["wander"])
