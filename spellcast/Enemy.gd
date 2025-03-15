extends CharacterBody2D
class_name Enemy

@export var animated_sprite: AnimatedSprite2D

var states: Dictionary
@export var direction:= 1
@export var speed:= 15
@export var gravity:= 2000

@onready var floor_check:= $FloorCheck
@onready var wall_check:= $WallCheck

@onready var start_pos:= position

func _ready():
	for state in $EnemyStateMachine.get_children():
		state._initalize($EnemyStateMachine, self, animated_sprite, state.name.to_lower())
		states[state.name.to_lower()] = state
	$EnemyStateMachine._initalize()

func _is_facing_wall():
	return wall_check.is_colliding()
	
func _is_on_ledge():
	return not floor_check.is_colliding()
	
func set_move():
	velocity.x = direction * speed
	
func stop():
	velocity.x = 0
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func flip():
	direction *= -1
	wall_check.target_position.x *= -1
	floor_check.position.x *= -1
	
func flip_sprite():
	pass #Define function in the specific enemy scripts
