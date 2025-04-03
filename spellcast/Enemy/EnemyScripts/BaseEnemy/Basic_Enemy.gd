extends Enemy
class_name BasicEnemy

@export var is_boss:bool
@export var boss_damage_multiplier:=1.5
@export var boss_health_multiplier:=1.5
@export var variant_material : Material

var vision: Vision

func _ready() -> void:
	super()
	vision = $Detector
	vision.body = self
	vision.target = player
	if is_boss:
		default_damage *= boss_damage_multiplier
		damage = default_damage
		max_health *= boss_health_multiplier
		health = max_health
		scale *= 1.3
		sprite.material = variant_material
	
func force_vision_update():
	can_see_target = vision._can_see_target()
	
func take_damage(_damage:int, _flinch:=true, _apply_frozen_multiplier:=true):
	super(_damage, _flinch, _apply_frozen_multiplier)
	if _flinch == true and $StateMachine.current_state != states["attack"] and $StateMachine.current_state != states["damaged"]:
		$StateMachine.change_state("damaged")
	
func respawn():
	remove_all_status_conditions()
	enable_functions_for_respawn()
	dead = false
	health = max_health
	position = start_pos
	$StateMachine._initialize()
	update_health_display()
	$HPbar.visible = true
	
func disable_functions_for_dead():
	vision.process_mode = Node.PROCESS_MODE_DISABLED
	attack_check.enabled = false
	floor_check.enabled = false
	wall_check.enabled = false
	set_collision_layer_value(2, false)
	
func enable_functions_for_respawn():
	vision.process_mode = Node.PROCESS_MODE_INHERIT
	attack_check.enabled = true
	floor_check.enabled = true
	wall_check.enabled = true
	set_collision_layer_value(2, true)
