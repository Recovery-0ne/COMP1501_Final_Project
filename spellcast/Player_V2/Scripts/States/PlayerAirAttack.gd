extends PlayerState

func _enter():
	super()

func _update(delta: float):
	super(delta)
	if player.is_on_floor():
		player.velocity.x = 0
	player.move()

func _exit():
	super()
	
func _animation_end():
	state_machine.change_state("fall")
