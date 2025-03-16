extends PlayerState


func _enter():
	animation_name = "cast_projectile" #Must manually set animation name since the animation is shared by other states, so has a generic name
	super()

func _update(delta: float):
	super(delta)
	
func _exit():
	super()

func _on_animations_animation_finished() -> void:
	if state_machine.current_state == self:
		state_machine.change_state("idle")

func _on_animations_frame_changed() -> void:
	if state_machine.current_state == self and not $Fireball.visible:
		$Fireball._activate(player, player.get_global_mouse_position())
