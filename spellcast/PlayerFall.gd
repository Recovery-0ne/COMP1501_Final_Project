extends PlayerState

func _enter():
	super()

func _update(delta: float):
	super(delta)
	if player.is_on_floor():
		state_machine.change_state(player.states["idle"])
	if player.position.y > 1500:
		player.position = Vector2(0,0)
	player.velocity.x = player.direction * player.speed * delta


func _exit():
	super()
