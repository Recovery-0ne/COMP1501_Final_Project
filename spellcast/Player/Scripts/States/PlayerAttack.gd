extends PlayerState

func _enter():
	animation_name = "attack_2"
	super()

func _update(delta: float):
	super(delta)

func _exit():
	super()
	
func _animation_end():
	state_machine.change_state("idle")
