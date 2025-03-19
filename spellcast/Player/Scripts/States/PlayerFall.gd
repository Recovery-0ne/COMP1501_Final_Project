extends PlayerState

func _enter():
	super()

func _update(delta: float):
	super(delta)
	if player.is_on_floor():
		state_machine.change_state("idle")
	elif Input.is_action_just_pressed("attack"):
		state_machine.change_state("air_attack")
	
func _physics_update(delta: float):
	super(delta)
	if player.position.y > 1500:
		player.position = Vector2(0,0)
	player.move()

func _exit():
	super()
