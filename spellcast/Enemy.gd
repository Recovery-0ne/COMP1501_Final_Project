extends CharacterBody2D
class_name Enemy

var states: Dictionary
var direction: int
var speed: int
var gravity = 2000


func _ready():
	for state in $EnemyStateMachine.get_children():
		state.initalize($EnemyStateMachine, self, $AnimatedSpriteSkeleton, state.name.to_lower())
		states[state.name.to_lower()] = state 
	$EnemyStateMachine.initalize()
	
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
		
