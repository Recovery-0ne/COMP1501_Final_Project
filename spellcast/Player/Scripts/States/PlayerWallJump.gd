extends PlayerState

func _enter():
	super()
	sprite.flip_h = player.get_wall_normal().x < 0
	player.attack_check.position.x = abs(player.attack_check.position.x) * player.get_wall_normal().x
	player.wall_check.target_position.x = abs(player.wall_check.target_position.x)*player.get_wall_normal().x
	player.velocity = Vector2(player.get_wall_normal().x*300, -player.jump_velocity)
	
	
func _update(delta: float):
	super(delta)
	if player.velocity.y >= 0:
		state_machine.change_state("fall")
	elif Input.is_action_just_pressed("attack"):
		state_machine.change_state("air_attack")
	elif Input.is_action_just_pressed("dash") and player.can_dash():
		player.dash()

	
func _physics_update(delta: float):
	super(delta)
	player.move_and_slide()

func _exit():
	super()
