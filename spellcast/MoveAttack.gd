extends PlayerState

func _enter():
	super()

func _update(delta: float):
	super(delta)
	player.velocity.x = player.direction * player.speed * delta

func _exit():
	super()

func _on_animations_animation_finished():
	if state_machine.current_state == self:
		state_machine.change_state(player.states["idle"])
		player.velocity.x = 0
