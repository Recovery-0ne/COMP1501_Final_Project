extends PlayerState

func _enter():
	animation_name = "dash"
	super()
	player.velocity.x = 1500*player.direction

func _update(delta: float):
	super(delta)
	if player.is_on_wall() and player.wall_check.is_colliding():
		state_machine.change_state("wall_climb")

func _physics_update(delta: float):
	super(delta)
	player.move_and_slide()

func _exit():
	super()

func _animation_end():
	state_machine.change_state("fall")
