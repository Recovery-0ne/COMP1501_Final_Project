extends EnemyState

func _enter():
	super()
	$Timer.start()
	
func _update(delta: float):
	super(delta)
	if enemy.can_see_target:
		state_machine.change_state(enemy.states["pursue"])
	if enemy.attack_check.is_colliding():
		state_machine.change_state(enemy.states["attack"])
	
func _exit():
	super()
	
func _on_timer_timeout() -> void:
	state_machine.change_state(enemy.states["wander"])
