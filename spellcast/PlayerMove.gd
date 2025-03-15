extends PlayerState

func _enter():
	super()


func _update(delta: float):
	super(delta)
	if player.direction == 0:
		state_machine.change_state(player.states["idle"])
	if Input.is_action_just_pressed("basic_attack"):
		state_machine.change_state(player.states["moveattack"])
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.change_state(player.states["jump"])
	player.velocity.x = player.direction * player.speed * delta

func _exit():
	super()
	player.velocity.x = 0
