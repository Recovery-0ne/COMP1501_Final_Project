extends PlayerState

func _enter():
	super()
	player.gravity = 0

func _update(delta: float):
	super(delta)
	if player.velocity.x == 0:
		state_machine.change_state("idle")
	elif Input.is_action_pressed("jump"):
		state_machine.change_state("jump")
	elif Input.is_action_just_pressed("attack"):
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

func _on_coyote_timer_timeout() -> void:
	state_machine.change_state("fall")
