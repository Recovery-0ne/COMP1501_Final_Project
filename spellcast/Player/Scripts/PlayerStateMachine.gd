extends Node

class_name StateMachine

@export var initial_state: PlayerState
var current_state: PlayerState

func _initialize():
	current_state = initial_state
	current_state._enter()

func change_state(new_state_name: String):
	#print_debug(current_state.name + "-->" + new_state_name)
	if not current_state.player.frozen and not current_state.player.dead:
		var new_state = current_state.player.states[new_state_name]
		current_state._exit()
		current_state = new_state
		current_state._enter()

func _process(delta: float):
	current_state._update(delta)
	
func _physics_process(delta: float):
	current_state._physics_update(delta)
