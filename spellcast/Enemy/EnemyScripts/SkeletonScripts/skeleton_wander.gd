extends EnemyState

func _enter():
	animation_name = "walk"
	super()
	enemy.set_move()
	enemy.change_facing_direction()
	
func _update(delta: float):
	super(delta)
	
	if enemy._is_facing_wall() or enemy._is_on_ledge():
		enemy.change_direction()
		state_machine.change_state("idle")
	elif enemy.can_see_target:
		state_machine.change_state("pursue")
	
func _exit():
	super()
	enemy.stop()
