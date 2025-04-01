extends EnemyState

func _enter():
	animation_name = "attack_1"
	super()
	
func _update(delta:float):
	super(delta)
	
func _physics_update(delta:float):
	super(delta)
	
func _exit():
	super()
	
func _animation_finished():
	state_machine.change_state("pursue")
