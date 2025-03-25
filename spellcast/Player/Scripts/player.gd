extends Entity
class_name Player

var direction:= 1
@export var checkpoint_position: Vector2
var wall_check

var ability_method := ["cast_fireball", "cast_frost", "cast_lightning_strike"]
var dash_restricted_states := ["attack", "air_attack", "move_attack", "dead", "wall_slide", "wall_climb", "dash"]
var fireball_restricted_states := ["attack", "air_attack", "move_attack", "dead", "wall_slide", "wall_climb"]
var frost_restricted_states := ["attack", "air_attack", "move_attack", "dead", "wall_slide", "wall_climb"]
var lightning_strike_restricted_states := ["attack", "air_attack", "move_attack", "dead", "wall_slide", "wall_climb"]

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
	if not $Spells/Fireball.visible and $FireballCooldownTimer.is_stopped() and not fireball_restricted_states.has($StateMachine.current_state.name.to_lower()):
		$FireballCooldownTimer.start()
		$Spells/Fireball._activate(self, get_global_mouse_position())

func cast_frost():
	if $FrostCooldownTimer.is_stopped() and not frost_restricted_states.has($StateMachine.current_state.name.to_lower()):
		$FrostCooldownTimer.start()
		$Spells/Frost._activate(self, get_global_mouse_position())
		
func cast_lightning_strike():
	print_debug("lightning")
	if is_lightning_strike_cooldown_done() and not lightning_strike_restricted_states.has($StateMachine.current_state.name.to_lower()):
		print_debug("can_do")
		for enemy in get_tree().get_nodes_in_group("Enemies"):
				if enemy.is_on_screen:
					print_debug("enemy on screen")
					enemy.lightning_strike()
					start_lightning_strike_cooldown()
		
func can_dash() -> bool:
	return $DashCooldownTimer.is_stopped() and not dash_restricted_states.has($StateMachine.current_state.name.to_lower())
	
func dash():
	if can_dash():
		$DashCooldownTimer.start()
		$StateMachine.change_state("dash")
	
func swap_abilities():
	#swap abilities by changing the method that will be called and update when the ability is used
	pass

func use_ability(ability_num:int):
	if ability_num <= ability_method.size() and ability_method[ability_num - 1] != "":
		call(ability_method[ability_num - 1])
	
	
