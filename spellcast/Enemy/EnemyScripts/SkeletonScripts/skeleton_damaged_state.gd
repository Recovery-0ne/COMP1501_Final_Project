extends EnemyState

func _enter():
	super()
	
func _update(delta: float):
	super(delta)
	
func _physics_update(delta: float):
	super(delta)
	
func _exit():
	super()

func _animation_finished():
	if not enemy.can_see_target:
		state_machine.change_state("look_around")
	else:
		state_machine.change_state("pursue")
