extends Entity
class_name Player

@export var checkpoint_position: Vector2
var direction:= 1
var wall_check

var ability_names := ["Fireball", "Frost", "LightningStrike"]
var available_abilities := ["", "Fireball", "Frost", "LightningStrike"]
var ability_methods := ["cast_fireball", "cast_frost", "cast_lightning_strike"]
var current_ability_methods := ["cast_fireball", "", "", ""]

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
	if is_lightning_strike_cooldown_done() and not lightning_strike_restricted_states.has($StateMachine.current_state.name.to_lower()):
		for enemy in get_tree().get_nodes_in_group("Enemies"):
				if enemy.is_on_screen:
					enemy.lightning_strike()
					start_lightning_strike_cooldown()
		
func can_dash() -> bool:
	return $DashCooldownTimer.is_stopped() and not dash_restricted_states.has($StateMachine.current_state.name.to_lower())
	
func dash():
	if can_dash():
		$DashCooldownTimer.start()
		$StateMachine.change_state("dash")

func use_ability(ability_num:int):
	if current_ability_methods[ability_num - 1] != "":
		call(current_ability_methods[ability_num - 1])
		
func get_nth_current_ability_name_from_method_name(n:int):
	var found = ability_methods.find(current_ability_methods[n])
	if found < 0 : return ""
	else: return ability_names[found]
	
func get_ability_method_from_name(ability_name:String):
	var found = ability_names.find(ability_name)
	if found < 0: return ""
	else: return ability_methods[found]
	
func change_ability(current_ability_index, available_ability_index):
	current_ability_methods[current_ability_index] = get_ability_method_from_name(available_abilities[available_ability_index])
