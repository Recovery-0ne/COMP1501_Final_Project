extends CharacterBody2D

class_name Player

var states: Dictionary
var direction = 1
var speed = 90000
var gravity = 2000
var jump_velocity = 800

func _ready():
	for state in $StateMachine.get_children():
		state.initialize($StateMachine, self, $Animations, state.name.to_lower())
		states[state.name.to_lower()] = state
	$StateMachine.initialize()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
