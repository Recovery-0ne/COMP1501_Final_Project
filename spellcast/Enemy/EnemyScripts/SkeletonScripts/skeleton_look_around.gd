extends EnemyState

var times_flipped = 0

func _enter():
	animation_name = "idle"
	super()
	_on_timer_timeout()
	
func _update(delta: float):
	super(delta)
	if enemy.can_see_target:
		state_machine.change_state("pursue")
	
func _exit():
	super()
	$Timer.stop()
	times_flipped = 0

func _on_timer_timeout() -> void:
	enemy.flip_facing_direction()
	times_flipped += 1
	
	if times_flipped > 2:
		state_machine.change_state("idle")
	else:
		$Timer.start()
