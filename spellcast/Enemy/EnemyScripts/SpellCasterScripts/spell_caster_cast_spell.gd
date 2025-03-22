extends EnemyState

func _enter():
	super()
	
func _update(delta: float):
	super(delta)
	
func _physics_update(delta: float):
	super(delta)
	
func _exit():
	super()
	
func cast_spell():
	print_debug("Cast a spell")
	
func _animation_end():
	state_machine.change_state("pursue")
