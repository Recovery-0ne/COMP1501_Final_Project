extends PlayerState

func _enter():
	super()

func _update(delta: float):
	super(delta)
	if player.direction != 0 and ((player.is_on_wall() and player.direction == (player.get_wall_normal().x/abs(player.get_wall_normal().x))) or not player.is_on_wall()):
		state_machine.change_state("move")
	elif Input.is_action_pressed("jump") and player.is_on_floor():
		state_machine.change_state("jump")
		player.jump_count += 1
	elif not player.is_on_floor():
		state_machine.change_state("fall")
	elif Input.is_action_pressed("attack"):
		state_machine.change_state("attack")
		
func _physics_update(delta:float):
	super(delta)
		
func _exit():
	super()
