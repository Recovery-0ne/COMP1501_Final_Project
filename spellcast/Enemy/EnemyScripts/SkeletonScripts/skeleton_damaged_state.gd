extends EnemyState

func _enter():
	super()
	
func _update(delta: float):
	super(delta)
	
func _exit():
	super()	


func _on_animated_sprite_2d_animation_finished() -> void:
	if state_machine.current_state == self:
		state_machine.change_state("pursue")
