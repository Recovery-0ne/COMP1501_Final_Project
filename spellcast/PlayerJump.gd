extends PlayerState

func _enter():
	super()
	player.velocity.y = -player.jump_velocity


func _update(delta: float):
	super(delta)
	if Input.is_action_just_pressed("basic_attack"):
		state_machine.change_state(player.states["jumpattack"])
	if player.velocity.y > 0:
		state_machine.change_state(player.states["fall"])
	player.velocity.x = player.direction * player.speed * delta

		

func _exit():
	super()
