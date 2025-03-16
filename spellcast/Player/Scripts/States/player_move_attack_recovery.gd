extends PlayerState

func _enter():
	super()

func _update(delta: float):
	super(delta)
	player.move()

func _exit():
	super()

func _on_animations_animation_finished():
	if state_machine.current_state == self and anim2D.frame_progress != 0:
		state_machine.change_state("idle")
