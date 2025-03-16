extends CharacterBody2D
class_name Enemy

@export var animated_sprite: AnimatedSprite2D

var player: Player
var last_known_player_position:= Vector2.ZERO
var looking_for_player:= false
var states: Dictionary
@export var move_dir:= 1
@export var facing_dir = 1
@export var speed:= 15
@export var gravity:= 2000

@onready var vision:= $Detector

@onready var floor_check:= $FloorCheck
@onready var wall_check:= $WallCheck
@onready var attack_check:= $AttackCheck

@onready var start_pos:= position

var can_see_target = false

func _ready():
	for state in $EnemyStateMachine.get_children():
		state._initalize($EnemyStateMachine, self, animated_sprite, state.name.to_lower())
		states[state.name.to_lower()] = state
	$EnemyStateMachine._initalize()
	self.add_to_group("Enemies")
	player = get_tree().get_nodes_in_group("Player")[0]
	vision.body = self
	vision.target = player

func _is_facing_wall():
	return wall_check.is_colliding()
	
func _is_on_ledge():
	return not floor_check.is_colliding()
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func change_direction():
	move_dir *= -1
	flip_checks()
	
func change_direction_to(directon: int):
	if move_dir != directon:
		move_dir = directon
		flip_checks()
	
func flip_checks():
	wall_check.target_position.x *= -1
	floor_check.position.x *= -1
