extends Entity
class_name Player

var direction:= 1
@export var checkpoint_position: Vector2
var wall_check

func _init() -> void:
	self.add_to_group("Player")

func _ready():
	facing_dir = direction
	checkpoint_position = global_position
	wall_check = $WallCheck
	for state in $StateMachine.get_children():
		state._initialize($StateMachine, self, sprite, anim, state.name.to_lower())
		states[state.name.to_lower()] = state
	$StateMachine._initialize()
	update_health_display()
		
func move(multiplier:=1.0):
	velocity.x = direction * speed * multiplier
	move_and_slide()

func damage_target():
	if attack_check.is_colliding():
		#Damage all colliding objects
		for i in attack_check.get_collision_count():
			attack_check.get_collider(i).take_damage(damage)
			
func take_damage(_damage:int, _flinch:=true, _apply_frozen_multiplier:=true):
	super(_damage, _flinch, _apply_frozen_multiplier)
	if _flinch and $StateMachine.current_state == states["idle"]:
		$StateMachine.change_state("damaged")
		
func respawn_player():
	remove_all_status_conditions()
	dead = false
	global_position = checkpoint_position
	$StateMachine._initialize()
	health = max_health
	update_health_display()
	$HealthLabel.visible = true
		
func cast_fireball():
	if not $StateMachine/Cast_Fireball/Fireball.visible and $FireballCooldownTimer.is_stopped():
		$FireballCooldownTimer.start()
		$StateMachine/Cast_Fireball/Fireball._activate(self, get_global_mouse_position())

func cast_frost():
	if not $StateMachine/Cast_Frost/Frost.visible and $FrostCooldownTimer.is_stopped():
		$FrostCooldownTimer.start()
		$StateMachine/Cast_Frost/Frost._activate(self, get_global_mouse_position())
		
func can_dash() -> bool:
	return $DashCooldownTimer.is_stopped()
	
func dash():
	$DashCooldownTimer.start()
	$StateMachine.change_state("dash")
