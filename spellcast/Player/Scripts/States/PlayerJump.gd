extends PlayerState

func _enter():
	super()
	player.velocity.y = -player.jump_velocity
		
func _update(delta: float):
	super(delta)
	if player.velocity.y >= 0:
		state_machine.change_state("fall")
	if Input.is_action_just_pressed("attack"):
		state_machine.change_state("air_attack")
	elif player.wall_check.is_colliding():
		state_machine.change_state("wall_climb")
	elif Input.is_action_just_pressed("dash"):
		state_machine.change_state("dash")
	


	
func _physics_update(delta: float):
	super(delta)
	if player.direction != 0: player.move()
	else: player.move_and_slide()
	
func _exit():
	super()
