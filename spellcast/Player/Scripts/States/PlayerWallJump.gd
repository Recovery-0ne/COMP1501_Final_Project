extends PlayerState

func _enter():
	super()
	player.flip_to(player.get_wall_normal().x)
	player.velocity = Vector2(player.get_wall_normal().x*300, -player.jump_velocity)
	player.sound_manager.play("jump")
	
func _update(delta: float):
	super(delta)
	if player.velocity.y >= 0:
		state_machine.change_state("fall")
	elif Input.is_action_just_pressed("attack"):
		state_machine.change_state("air_attack")
	
func _physics_update(delta: float):
	super(delta)
	player.move_and_slide()

func _exit():
	super()
