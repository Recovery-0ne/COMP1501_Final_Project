extends EnemyState

func _enter():
	animation_name = "walk"
	super()
	enemy.set_move()
	
func _update(delta: float):
	super(delta)
	
	if enemy._is_facing_wall() or enemy._is_on_ledge():
		enemy.flip()
		state_machine.change_state(enemy.states["idle"])
	
func _exit():
	super()
	enemy.stop()
