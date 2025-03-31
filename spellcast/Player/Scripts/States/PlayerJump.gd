extends PlayerState

func _enter():
	super()
	player.velocity.y = -player.jump_velocity
	player.sound_manager.play("jump")
		
func _update(delta: float):
	super(delta)
	if player.velocity.y >= 0:
		state_machine.change_state("fall")
	elif Input.is_action_just_pressed("attack"):
		state_machine.change_state("air_attack")
	elif player.wall_check.is_colliding():
		state_machine.change_state("wall_climb")
	
func _physics_update(delta: float):
	super(delta)
	player.move()
	
func _exit():
	super()
