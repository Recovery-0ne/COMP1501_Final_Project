extends PlayerState

func _enter():
	super()
	
func _update(delta: float):
	super(delta)
	
func _physics_update(delta:float):
	super(delta)
	
func _exit():
	super()
	
func animation_finished():
	state_machine.change_state("idle")
