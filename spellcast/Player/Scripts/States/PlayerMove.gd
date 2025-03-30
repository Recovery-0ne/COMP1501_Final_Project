extends PlayerState

func _enter():
	super()
	player.gravity = 0
	_on_step_timer_timeout()

func _update(delta: float):
	super(delta)
	if player.velocity.x == 0:
		state_machine.change_state("idle")
	elif Input.is_action_pressed("jump"):
		state_machine.change_state("jump")
		player.jump_count += 1
	elif Input.is_action_pressed("attack"):
		state_machine.change_state("move_attack")
	elif not player.is_on_floor() and $CoyoteTimer.is_stopped():
		$CoyoteTimer.start()
	
func _physics_update(delta: float):
	super(delta)
	player.move()

func _exit():
	super()
	player.gravity = player.default_gravity
	$CoyoteTimer.stop()
	$StepTimer.stop()

func _on_coyote_timer_timeout() -> void:
	state_machine.change_state("fall")

func _on_step_timer_timeout() -> void:
	player.sound_manager.play("walk")
	$StepTimer.start()
