extends PlayerState

func _enter():
	animation_name = "attack_3"
	super()

func _update(delta: float):
	super(delta)
	
func _physics_update(delta: float):
	super(delta)
	player.move()

func _exit():
	super()
	
func _animation_end():
	state_machine.change_state("move")
