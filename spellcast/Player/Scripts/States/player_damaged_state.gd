extends PlayerState

func _enter():
	super()
	
func _update(delta: float):
	super(delta)
	if Input.is_anything_pressed():
		state_machine.change_state("idle")
	
func _exit():
	super()	
	
func _animation_end():
	state_machine.change_state("idle")
