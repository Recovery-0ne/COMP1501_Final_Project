extends PlayerState


func _enter():
	animation_name = "cast_projectile" #Must manually set animation name since the animation is shared by other states, so has a generic name
	super()
	await get_tree().create_timer(0.3).timeout
	player.cast_fireball()

func _update(delta: float):
	super(delta)
	
func _exit():
	super()

func _on_animations_animation_finished() -> void:
	if state_machine.current_state == self:
		state_machine.change_state("idle")
