extends PlayerState

func _enter():
	super()

func _update(delta: float):
	super(delta)
	if Input.is_anything_pressed():
		state_machine.change_state("idle")

func _exit():
	super()

func _on_animations_animation_finished():
	if state_machine.current_state == self and anim2D.frame_progress != 0:
		state_machine.change_state("idle")
