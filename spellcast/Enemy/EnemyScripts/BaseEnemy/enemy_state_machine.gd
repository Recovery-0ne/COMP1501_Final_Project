extends Node
class_name StateMachineEnemy

@export var inital_state: EnemyState
var current_state: EnemyState

func _initialize():
	current_state = inital_state
	current_state._enter()
	
func change_state(new_state_name: String):
	if ((current_state.enemy.frozen and current_state.enemy is BasicEnemy) or current_state.enemy.dead):
		return
	#print_debug(current_state.name + "--->" + new_state_name)
	var new_state = current_state.enemy.states[new_state_name]
	current_state._exit()
	current_state = new_state
	current_state._enter()
	
func _physics_process(delta: float) -> void:
	current_state._physics_update(delta)

func _process(delta: float):
	current_state._update(delta)
