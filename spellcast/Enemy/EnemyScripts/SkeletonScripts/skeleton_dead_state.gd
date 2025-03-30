extends EnemyState

func _enter():
	super()
	enemy.disable_functions_for_dead()
	
func _update(delta: float):
	super(delta)
	if enemy.is_on_floor():
		enemy.velocity = Vector2.ZERO
	
func _physics_update(delta: float):
	super(delta)
	
func _exit():
	super()
