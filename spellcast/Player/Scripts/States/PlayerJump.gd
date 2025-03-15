extends PlayerState

func _enter():
	super()
	player.velocity.y = -player.jump_velocity

func _update(delta: float):
	super(delta)
	if player.velocity.y > 0:
		state_machine.change_state(player.states["fall"])
	if Input.is_action_just_pressed("attack"):
		state_machine.change_state(player.states["air_attack"])
	player.move()		

func _exit():
	super()
