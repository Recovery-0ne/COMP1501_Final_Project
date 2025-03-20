extends Entity
class_name Enemy

var player: Player

@export var flip_on_start:=false

@export var pursuit_speed_multiplier:=1
@export var move_dir:= 1
@onready var facing_dir:= move_dir

@onready var vision:= $Detector

@onready var floor_check:= $FloorCheck
@onready var wall_check:= $WallCheck

@onready var start_pos:= position

var can_see_target = false
var is_on_screen = false

func _ready():
	$LightningStrike.target = self
	$VisibleOnScreenNotifier2D.connect("screen_entered", on_screen)
	$VisibleOnScreenNotifier2D.connect("screen_exited", off_screen)
	for state in $StateMachine.get_children():
		state._initialize($StateMachine, self, sprite, anim, state.name.to_lower())
		states[state.name.to_lower()] = state
	$StateMachine._initialize()
	self.add_to_group("Enemies")
	player = get_tree().get_nodes_in_group("Player")[0]
	vision.body = self
	vision.target = player
	update_health_display()
	if flip_on_start: 
		change_direction()

func _is_facing_wall():
	return wall_check.is_colliding()
	
func _is_on_ledge():
	return not floor_check.is_colliding()
		
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
	super(_damage, _flinch)
	if health == 0:
		$StateMachine.change_state("dead")
		$HealthLabel.visible = false
		dead = true
	else:
		#If an enemy was hit and it can't see the player, it is possible they are behind it
		if can_see_target == false:
			change_direction()
			$StateMachine.change_state("pursue")
		if $StateMachine.current_state != states["attack"] and _flinch == true:
			$StateMachine.change_state("damaged")

func on_screen():
	is_on_screen = true
	
func off_screen():
	is_on_screen = false
