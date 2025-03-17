extends PlayerState

func _enter():
	#print_debug("idle")
	super()

func _update(delta: float):
	super(delta)
	if player.direction != 0:
		state_machine.change_state("move")
	if Input.is_action_pressed("jump") and player.is_on_floor():
		state_machine.change_state("jump")
	if not player.is_on_floor():
		state_machine.change_state("fall")
	if Input.is_action_pressed("fireball"):
		state_machine.change_state("cast_fireball")
	if Input.is_action_pressed("attack"):
		state_machine.change_state("attack")
		
func _exit():
	super()
