extends PlayerState

func _enter():
	super()


func _update(delta: float):
	super(delta)
	if player.direction == 0:
		state_machine.change_state(player.states["idle"])
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.change_state(player.states["jump"])
	if Input.is_action_just_pressed("attack"):
		state_machine.change_state(player.states["move_attack"])
	player.move()

func _exit():
	super()
