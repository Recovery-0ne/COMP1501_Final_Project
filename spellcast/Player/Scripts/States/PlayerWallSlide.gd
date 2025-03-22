extends PlayerState
var wall_normal = 0

func _enter():
	super()
	wall_normal = player.get_wall_normal().x
	player.gravity = 0
	player.velocity.y = 100


func _update(delta: float):
	super(delta)
	player.velocity.x = -wall_normal
	var input = Input.get_axis("down", "up")
	if player.is_on_floor():
		sprite.flip_h = wall_normal < 0
		player.attack_check.position.x = abs(player.attack_check.position.x) * wall_normal
		state_machine.change_state("idle")
	elif input > 0:
		state_machine.change_state("wall_climb")
	#elif not player.is_on_wall() or player.direction == wall_normal:
		#state_machine.change_state("fall")

	if (Input.is_action_pressed("left") and player.velocity.x > 0) or (Input.is_action_pressed("right") and player.velocity.x < 0):
		state_machine.change_state("fall")
	elif not player.is_on_wall():
		state_machine.change_state("idle")

func _physics_update(delta: float):
	super(delta)
	player.move_and_slide()

func _exit():
	super()
	player.gravity = player.default_gravity
	player.velocity.y = 0
