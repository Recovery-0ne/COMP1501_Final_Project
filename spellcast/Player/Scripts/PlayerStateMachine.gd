extends Node

class_name StateMachine

@export var initial_state: PlayerState
var current_state: PlayerState

func initialize():
	current_state = initial_state
	current_state._enter()

func change_state(new_state: PlayerState):
	current_state._exit()
	current_state = new_state
	current_state._enter()

func _process(delta):
	current_state._update(delta)
