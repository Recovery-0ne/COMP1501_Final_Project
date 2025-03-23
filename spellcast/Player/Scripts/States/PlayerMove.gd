extends PlayerState

func _enter():
	super()


func _update(delta: float):
	super(delta)
	if player.velocity.x == 0:
		state_machine.change_state("idle")
	elif Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.change_state("jump")
	elif Input.is_action_just_pressed("attack"):
		state_machine.change_state("move_attack")
	elif Input.is_action_just_pressed("dash"):
		state_machine.change_state("dash")

		

	
func _physics_update(delta: float):
	super(delta)
	player.move()

func _exit():
	super()
