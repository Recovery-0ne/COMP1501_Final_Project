extends PlayerState
var wall_normal = 0

func _enter():
	super()
	wall_normal = player.get_wall_normal().x
	player.gravity = 0
	player.velocity.y = 0

func _update(delta: float):
	super(delta)
	if Input.is_action_pressed("jump"):
		state_machine.change_state("wall_jump")
	player.velocity.x = -wall_normal
	var input = Input.get_axis("down", "up")
	if input < 0:
		state_machine.change_state("wall_slide")
	elif player.is_on_floor():
		state_machine.change_state("idle")
	if (Input.is_action_pressed("left") and player.velocity.x > 0) or (Input.is_action_pressed("right") and player.velocity.x < 0):
		state_machine.change_state("fall")
	elif not player.is_on_wall():
		state_machine.change_state("idle")



	#elif player.direction == wall_normal:
	#	state_machine.change_state("fall")
	#elif not player.is_on_wall() or player.direction == wall_normal:
	#	state_machine.change_state("fall")
	
	player.velocity.y = -100*input
	anim.speed_scale = input
	
func _physics_update(delta: float):
	super(delta)
	player.move_and_slide()


func _exit():
	super()
	player.gravity = player.default_gravity
