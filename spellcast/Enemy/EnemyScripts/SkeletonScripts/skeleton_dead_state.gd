extends EnemyState

func _enter():
	super()
	enemy.disable_functions_for_dead()
	
func _update(delta: float):
	super(delta)
	
func _physics_update(delta: float):
	super(delta)
	
func _exit():
	super()
