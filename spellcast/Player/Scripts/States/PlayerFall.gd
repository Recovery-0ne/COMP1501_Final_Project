extends PlayerState

func _enter():
	super()

func _update(delta: float):
	super(delta)
	if player.is_on_floor():
		player.jump_count = 0
	if player.is_on_floor():
		state_machine.change_state("idle")
	elif Input.is_action_just_pressed("attack"):
		state_machine.change_state("air_attack")
	elif player.wall_check.is_colliding():
		state_machine.change_state("wall_climb")
	elif Input.is_action_just_pressed("dash"):
		state_machine.change_state("dash")
	elif Input.is_action_just_pressed("jump") and (player.jump_count < player.max_jumps):
		state_machine.change_state("jump")
		player.jump_count += 1



	
func _physics_update(delta: float):
	super(delta)
	if player.position.y > 1500:
		player.respawn_player()
	if player.direction != 0: player.move()
	else: player.move_and_slide()

func _exit():
	super()
