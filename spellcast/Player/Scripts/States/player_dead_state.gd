extends PlayerState

func _enter():
	super()
	player.gravity = player.default_gravity
	
func _update(delta: float):
	super(delta)
	
func _physics_update(delta:float):
	super(delta)
	if player.is_on_floor():
		player.velocity.x = 0
	player.move_and_slide()
	
func _exit():
	super()
