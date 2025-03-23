extends PlayerState
var wall_normal = 0
var defaultAnimSpeed = 1
func _enter():
	super()
	var defaultAnimSpeed = anim.speed_scale
	wall_normal = player.get_wall_normal().x
	player.gravity = 0
	player.velocity.y = 0

func _update(delta: float):
	super(delta)
	player.velocity.x = -wall_normal
	var input = Input.get_axis("down", "up")
	
	if Input.is_action_pressed("jump"):
		state_machine.change_state("wall_jump")
	
	if input > 0 and not Input.is_action_pressed("jump"):
		player.velocity.y = -100*input
		anim.speed_scale = input
	elif input < 0 and not Input.is_action_pressed("jump"):
		state_machine.change_state("wall_slide")
	elif not Input.is_action_pressed("jump"):
		player.velocity.y = 0
		anim.speed_scale = 0
		
	if player.is_on_floor():
		state_machine.change_state("idle")
		
	if (Input.is_action_pressed("left") and player.velocity.x > 0) or (Input.is_action_pressed("right") and player.velocity.x < 0):
		state_machine.change_state("fall")
	elif not player.is_on_wall():
		state_machine.change_state("idle")



	#elif player.direction == wall_normal:
	#	state_machine.change_state("fall")
	#elif not player.is_on_wall() or player.direction == wall_normal:
	#	state_machine.change_state("fall")

	#This code was the reason a lot of things was glitching/breaking for some reason vvv
	#code made it so aniamtions
	#player.velocity.y = -100*input
	#anim.speed_scale = input
	#This code was the reason a lot of things was glitching/breaking for some reason ^^^
	
func _physics_update(delta: float):
	super(delta)
	player.move_and_slide()


func _exit():
	super()
	player.gravity = player.default_gravity
	anim.speed_scale = defaultAnimSpeed
