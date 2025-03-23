extends PlayerState
var wall_normal = 0

func _enter():
	super()
	wall_normal = player.get_wall_normal().x
	player.gravity = 0
	player.velocity.y = 100


func _update(delta: float):
	super(delta)
	var input = Input.get_axis("down", "up")
	if player.is_on_floor():
		sprite.flip_h = player.get_wall_normal().x < 0
		player.attack_check.position.x = abs(player.attack_check.position.x) * player.get_wall_normal().x
		player.wall_check.target_position.x = abs(player.wall_check.target_position.x)*player.get_wall_normal().x
		state_machine.change_state("idle")
		return
	elif input > 0:
		state_machine.change_state("wall_climb")
		return
	elif Input.is_action_pressed("jump"):
		state_machine.change_state("wall_jump")
		return
	elif player.direction == wall_normal:
		state_machine.change_state("fall")
		return
	elif not player.is_on_wall() and not player.wall_check.is_colliding():
		state_machine.change_state("idle")
		return

func _physics_update(delta: float):
	super(delta)
	player.move_and_slide()

func _exit():
	super()
	player.gravity = player.default_gravity
	player.velocity.y = 0
