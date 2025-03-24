extends PlayerState
@export var spell:Node2D

func _enter():
	super()

func _update(delta: float):
	super(delta)
	
func _physics_update(delta:float):
	super(delta)
	
func _exit():
	super()
	
func _animation_finished():
	player.cast_projectile_spell(spell, $Cast_Timer)
	state_machine.change_state("idle")
