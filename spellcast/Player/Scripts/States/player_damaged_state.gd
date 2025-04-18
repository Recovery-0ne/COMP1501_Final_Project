extends PlayerState

func _enter():
	super()
	
func _update(delta: float):
	if Input.is_anything_pressed():
		state_machine.change_state("idle")
	super(delta)
		
func _physics_update(delta:float):
	super(delta)
	
func _exit():
	super()	
	
func _animation_end():
	state_machine.change_state("idle")
