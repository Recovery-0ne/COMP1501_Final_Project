extends PlayerState

func _enter():
	super()
	player.start_melee_combo_cooldown_timer()
	
func _update(delta: float):
	super(delta)
	
func _physics_update(delta:float):
	super(delta)
	
func _exit():
	super()
	
func animation_finished():
	state_machine.change_state("idle")
