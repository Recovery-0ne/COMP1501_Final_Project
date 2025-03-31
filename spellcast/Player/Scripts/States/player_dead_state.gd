extends PlayerState

func _enter():
	super()
	player.gravity = player.default_gravity
	
func _update(delta: float):
	super(delta)
	
func _physics_update(delta:float):
	super(delta)
	player.move_and_slide()
	
func _exit():
	super()
