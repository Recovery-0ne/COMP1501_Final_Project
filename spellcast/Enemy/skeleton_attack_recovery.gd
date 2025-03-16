extends EnemyState

func _enter():
	super()
	
func _update(delta: float):
	super(delta)
	
func _exit():
	super()

func _on_animated_sprite_2d_animation_finished() -> void:
	#Check that the frame progress has increased because otherwise, since this state is transitioned to from 
		#another that ends when the animation_finished signal is sent, this state will immediately be exited
	if state_machine.current_state == self and animated_sprite.frame_progress != 0:
		state_machine.change_state(enemy.states["idle"])
