extends PlayerState
var wall_normal = 0

func _enter():
	super()
	wall_normal = player.get_wall_normal().x
	player.gravity = 15


func _update(delta: float):
	super(delta)
	var input = Input.get_axis("down", "up")
	if player.is_on_floor():
		player.flip_to(player.get_wall_normal().x)
		state_machine.change_state("idle")
	elif input > 0:
		state_machine.change_state("wall_climb")
	elif Input.is_action_pressed("jump"):
		state_machine.change_state("wall_jump")
	elif player.direction == wall_normal:
		state_machine.change_state("fall")
	elif not player.is_on_wall() and not player.wall_check.is_colliding():
		state_machine.change_state("idle")

func _physics_update(delta: float):
	super(delta)
	player.move_and_slide()

func _exit():
	super()
	player.gravity = player.default_gravity
	player.velocity.y = 0
