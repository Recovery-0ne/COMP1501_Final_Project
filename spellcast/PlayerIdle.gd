extends PlayerState

func _enter():
	#print_debug("idle")
	super()

func _update(delta: float):
	super(delta)
	if player.direction != 0:
		state_machine.change_state(player.states["move"])
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.change_state(player.states["jump"])
	if not player.is_on_floor():
		state_machine.change_state(player.states["fall"])
	if Input.is_action_just_pressed("fireball"):
		state_machine.change_state(player.states["cast_fireball"])
func _exit():
	super()
