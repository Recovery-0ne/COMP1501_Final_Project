extends CharacterBody2D
class_name Enemy

@export var animated_sprite: AnimatedSprite2D

var player: Player
#var last_known_player_position:= Vector2.ZERO
#var looking_for_player:= false
var states: Dictionary

@export var flip_on_start:=false
@export var max_health:= 100
@onready var health:= max_health
@export var damage:= 5
@export var speed:= 15
@export var pursuit_speed_multiplier:=1
@export var gravity:= 2000
@export var move_dir:= 1
@onready var facing_dir:= move_dir

@onready var vision:= $Detector

@onready var floor_check:= $FloorCheck
@onready var wall_check:= $WallCheck
@onready var attack_check:= $AttackCheck

@onready var start_pos:= position

var can_see_target = false
#var has_seen_target = false
var dead:= false

func _ready():
	for state in $StateMachine.get_children():
		state._initalize($StateMachine, self, animated_sprite, state.name.to_lower())
		states[state.name.to_lower()] = state
	$StateMachine._initalize()
	self.add_to_group("Enemies")
	player = get_tree().get_nodes_in_group("Player")[0]
	vision.body = self
	vision.target = player
	update_health_display()
	if flip_on_start: change_direction()

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
	
func damage_target():
	if attack_check.is_colliding():
		player.take_damage(damage)
		
func take_damage(_damage:int, _flinch:=true):
	if dead: return
	health = clamp(health - _damage, 0, max_health)
	if health == 0:
		dead = true
		$StateMachine.change_state("dead")
		$HealthLabel.visible = false
	else:
		#If an enemy was hit and it can't see the player, it is possible they are behind it
		if can_see_target == false:
			change_direction()
			$StateMachine.change_state("pursue")
		if $StateMachine.current_state != states["attack"] and _flinch == true:
			$StateMachine.change_state("damaged")
	update_health_display()
		
func update_health_display():
	$HealthLabel.text = str(health)
