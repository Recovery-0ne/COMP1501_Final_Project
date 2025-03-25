extends PlayerState

func _enter():
	super()

func _update(delta: float):
	super(delta)
	
func _physics_update(delta:float):
	super(delta)
	
func _exit():
	super()
	
func _animation_finished():
	player.call(name.to_lower())
	state_machine.change_state("idle")
