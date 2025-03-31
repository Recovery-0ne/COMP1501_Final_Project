extends PlayerState
var wall_normal = 0
var defaultAnimSpeed
func _enter():
	super()
	defaultAnimSpeed = anim.speed_scale
	wall_normal = player.get_wall_normal().x
	player.gravity = 0
	player.velocity.y = 0
	player.direction = 0

func _update(delta: float):
	super(delta)
	var input = Input.get_axis("down", "up")
	
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("wall_jump")
		return
	elif player.direction == wall_normal:
		state_machine.change_state("fall")
		return
		
	if not player.wall_check.is_colliding():
		player.velocity.y = 0
		anim.speed_scale = 0
		$SoundTimer.stop()
	if input > 0 and player.wall_check.is_colliding():
		player.velocity.y = -100*input
		anim.speed_scale = input
		if $SoundTimer.is_stopped():
			$SoundTimer.start()
	elif input < 0:
		state_machine.change_state("wall_slide")
		return
	else:
		player.velocity.y = 0
		anim.speed_scale = 0
		$SoundTimer.stop()
		
	if player.is_on_floor():
		state_machine.change_state("idle")

func _physics_update(delta: float):
	super(delta)
	player.move_and_slide()

func _exit():
	super()
	player.gravity = player.default_gravity
	anim.speed_scale = defaultAnimSpeed
	$SoundTimer.stop()


func _on_sound_timer_timeout() -> void:
	player.sound_manager.play("climb")
	$SoundTimer.start()
