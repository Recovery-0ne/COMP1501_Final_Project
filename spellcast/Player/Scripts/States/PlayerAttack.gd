extends PlayerState

func _enter():
	super()

func _update(delta: float):
	super(delta)
	if player.direction != 0: #Cancel the attack if the player moves
		state_machine.change_state("move")

func _exit():
	super()
	player.damage_target()

func _on_animations_animation_finished():
	if state_machine.current_state == self:
		state_machine.change_state("attack_recovery")
