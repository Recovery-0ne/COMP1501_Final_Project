extends PlayerState

func _enter():
	super()

func _update(delta: float):
	super(delta)
	if player.direction != 0:
		state_machine.change_state("move")
	elif Input.is_action_pressed("jump") and player.is_on_floor():
		state_machine.change_state("jump")
	elif not player.is_on_floor():
		state_machine.change_state("fall")
	elif Input.is_action_pressed("fireball"):
		state_machine.change_state("cast_fireball")
	elif Input.is_action_pressed("frost"):
		state_machine.change_state("cast_frost")
	elif Input.is_action_pressed("attack"):
		state_machine.change_state("attack")


		
func _physics_update(delta:float):
	super(delta)
		
func _exit():
	super()
