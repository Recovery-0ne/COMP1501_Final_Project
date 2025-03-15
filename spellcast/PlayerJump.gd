extends PlayerState

func _enter():
	super()
	player.velocity.y = -player.jump_velocity


func _update(delta: float):
	super(delta)
	if player.velocity.y > 0:
		state_machine.change_state(player.states["fall"])
	player.velocity.x = player.direction * player.speed * delta

		

func _exit():
	super()
