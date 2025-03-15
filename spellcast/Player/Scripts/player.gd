extends CharacterBody2D

class_name Player

var states: Dictionary
var direction = 1
var speed = 500
var gravity = 65
var jump_velocity = 1000

func _ready():
	for state in $StateMachine.get_children():
		state.initialize($StateMachine, self, $Animations, state.name.to_lower())
		states[state.name.to_lower()] = state
	$StateMachine.initialize()

func apply_gravity():
	if not is_on_floor():
		velocity.y += gravity
		
func move(multiplier:=1.0):
	velocity.x = direction * speed * multiplier
	move_and_slide()
		
