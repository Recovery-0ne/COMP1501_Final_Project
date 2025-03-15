extends Node
class_name StateMachineEnemy

@export var inital_state: EnemyState
var current_state: EnemyState

func initalize():
	current_state = inital_state
	current_state.enter()
	
	
func change_state(new_state: EnemyState):
	current_state.exit()
	current_state = new_state
	current_state.enter()
	

func _process(delta: float):
	current_state.update(delta)
