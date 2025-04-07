extends PlayerState

@onready var default_step_time = $StepTimer.wait_time
@onready var time_left = default_step_time

func _enter():
	super()
	player.gravity = 0
	if time_left == 0: 
		time_left = default_step_time
	$StepTimer.wait_time = time_left/2
	$StepTimer.start()

func _update(delta: float):
	super(delta)
	
func _physics_update(delta: float):
	super(delta)
	player.move()
	if player.velocity.x == 0:
		state_machine.change_state("idle")
	elif Input.is_action_pressed("jump"):
		state_machine.change_state("jump")
		player.jump_count += 1
	elif Input.is_action_pressed("attack"):
		state_machine.change_state("move_attack")
	elif not player.is_on_floor() and $CoyoteTimer.is_stopped():
		$CoyoteTimer.start()
	time_left = $StepTimer.time_left

func _exit():
	super()
	player.gravity = player.default_gravity
	$CoyoteTimer.stop()
	$StepTimer.stop()

func _on_coyote_timer_timeout() -> void:
	state_machine.change_state("fall")

func _on_step_timer_timeout() -> void:
	player.sound_manager.play("walk")
	$StepTimer.wait_time = default_step_time
	$StepTimer.start()
