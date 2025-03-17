extends Node
class_name StateMachineEnemy

@export var inital_state: EnemyState
var current_state: EnemyState

func _initalize():
	current_state = inital_state
	current_state._enter()
	
func change_state(new_state_name: String):
	#Just in case some transition brought the enemy out of the dead state when it shouldn't have
	if current_state.enemy.dead and current_state == current_state.enemy.states["dead"]:
		return
	var new_state = current_state.enemy.states[new_state_name]
	current_state._exit()
	current_state = new_state
	current_state._enter()

func _process(delta: float):
	current_state._update(delta)
