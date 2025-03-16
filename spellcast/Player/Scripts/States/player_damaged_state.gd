extends PlayerState

func _enter():
	super()
	
func _update(delta: float):
	super(delta)
	if Input.is_anything_pressed():
		state_machine.change_state("idle")
	player.move_and_slide()
	
func _exit():
	super()	

func _on_animations_animation_finished() -> void:
	if state_machine.current_state == self:
		state_machine.change_state("idle")
