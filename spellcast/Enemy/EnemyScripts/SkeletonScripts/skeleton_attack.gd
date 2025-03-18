extends EnemyState

func _enter():
	super()
	
func _update(delta: float):
	super(delta)
	
func _exit():
	super()
	
func _animation_finished():
	state_machine.change_state("pursue")
