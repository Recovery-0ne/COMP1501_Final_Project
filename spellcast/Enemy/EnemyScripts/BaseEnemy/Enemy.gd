extends Entity
class_name Enemy

var player: Player

@export var flip_on_start:=false

@export var sprite_offset = {1:Vector2.ZERO, -1:Vector2.ZERO} #keys are the directions

@export var pursuit_speed_multiplier:=1
@export var move_dir:= 1

@onready var floor_check:= $FloorCheck
@onready var wall_check:= $WallCheck
@onready var body_collider = $BodyCollider

@onready var start_pos:= position

var can_see_target = false

var is_on_screen = false

func _ready():
	facing_dir = move_dir
	player = get_tree().get_nodes_in_group("Player")[0]
	
	$VisibleOnScreenNotifier2D.connect("screen_entered", on_screen)
	$VisibleOnScreenNotifier2D.connect("screen_exited", off_screen)
	$LightningStrike.target = self
	
	for state in $StateMachine.get_children():
		state._initialize($StateMachine, self, sprite, anim, state.name.to_lower())
		states[state.name.to_lower()] = state
	$StateMachine._initialize()
	
	self.add_to_group("Enemies")
	
	if flip_on_start: 
		change_direction()
	update_health_display()

func on_screen():
	is_on_screen = true
	
func off_screen():
	is_on_screen = false

func _is_facing_wall():
	return wall_check.is_colliding()
	
func _is_on_ledge():
	return not floor_check.is_colliding()
	
func will_target_player():
	return can_see_target and not _is_facing_wall() and not _is_on_ledge()
		
func change_direction():
	move_dir *= -1
	flip_checks()
	
func change_direction_to(directon: int):
	if move_dir != directon:
		move_dir = directon
		flip_checks()
		
func change_direction_to_player():
	if player.position.x - position.x == 0: return
	change_direction_to((player.position.x - position.x)/abs(player.position.x - position.x))
	
func flip_checks():
	wall_check.target_position.x *= -1
	floor_check.position.x *= -1
	
func damage_target():
	if attack_check.is_colliding():
		player.take_damage(damage)
		
func take_damage(_damage:int, _flinch:=true, _apply_frozen_multiplier:=true):
	super(_damage, _flinch, _apply_frozen_multiplier)
	if health <= 0:
		player.set_money(player.player_money + 10)
		
func end_frozen_effect():
	super()
