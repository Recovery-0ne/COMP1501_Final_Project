extends PlayerState

func _enter():
	super()
	player.velocity.x = 1500 * player.facing_dir
	player.sound_manager.play("dash")

func _update(delta: float):
	super(delta)
	if player.wall_check.is_colliding():
		state_machine.change_state("wall_climb")

func _physics_update(delta: float):
	super(delta)
	player.move_and_slide()

func _exit():
	super()

func _animation_end():
	state_machine.change_state("fall")
