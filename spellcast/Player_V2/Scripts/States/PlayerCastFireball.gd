extends PlayerState


func _enter():
	super()

func _update(delta: float):
	super(delta)
	
func _exit():
	super()
	
func _animation_finished():
	player.cast_fireball()
	state_machine.change_state("idle")
