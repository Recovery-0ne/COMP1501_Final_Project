extends PlayerState

func _enter():
	super()

func _update(delta: float):
	super(delta)
	if player.is_on_floor():
		state_machine.change_state("idle")
	elif Input.is_action_just_pressed("attack"):
		state_machine.change_state("air_attack")
	elif player.wall_check.is_colliding():
		state_machine.change_state("wall_climb")
	
func _physics_update(delta: float):
	super(delta)
	if player.position.y > 1500:
		player.respawn_player()
	if player.direction == 0 and player.velocity.x != 0:
		player.move_and_slide()
	else:
		player.move()

func _exit():
	super()
