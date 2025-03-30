extends Entity
class_name Player

@export var checkpoint_position: Vector2
var direction:= 1
var wall_check
var jump_count = 0
var max_jumps = 2

var ability_names := ["Fireball", "Frost", "MeleeCombo", "LightningStrike"] #Store all names of abilities
var available_abilities := [""] #Store all names of unlocked abilities. Empty string represents no ability
var ability_methods := ["cast_fireball", "cast_frost", "use_melee_combo", "cast_lightning_strike"] #Store method names of all abilites (indices should match the names array)
var current_ability_methods := ["", "", "", ""] #Store method names of the currently equipped abilities

#Store the names of states that each ability can't be used in
var dash_restricted_states := ["attack", "air_attack", "move_attack", "dead", "wall_slide", "wall_climb"]
var fireball_restricted_states := ["attack", "air_attack", "move_attack", "dead", "wall_slide", "wall_climb"]
var frost_restricted_states := ["attack", "air_attack", "move_attack", "dead", "wall_slide", "wall_climb"]
var lightning_strike_restricted_states := ["attack", "air_attack", "move_attack", "dead", "wall_slide", "wall_climb"]
var melee_combo_restricted_states := ["attack", "air_attack", "move_attack", "dead", "wall_slide", "wall_climb", "dash", "jump", "wall_jump", "fall"]

#Make a dictionary for all the descriptions of the player's abilities
var ability_descriptions = {"Fireball":"Cast a fireball in the direction of your cursor. Deals little damage on hit, but has a 100% chance to apply burning to the opponent.", 
							"Frost":"Cast a ball of ice in the direction of your cursor. Deals little damage on hit, but has a 100% chance to apply freezing to the opponent.",
							"MeleeCombo":"Strike the opponent with a series of 3 hits",
							"LightningStrike":"Strike all opponents on the screen with a bolt of lightning. If the target is frozen, deal 50% more damage and remove the frozen effect. Otherwise, deal base damage with a 25% chance to apply burning."}

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
	
func flip_to(dir:int):
	facing_dir = dir
	sprite.flip_h = dir < 0
	attack_check.position.x = abs(attack_check.position.x) * dir
	wall_check.target_position.x = abs(wall_check.target_position.x) * dir
		
func move(multiplier:=1.0):
	velocity.x = direction * speed * multiplier
	move_and_slide()

func damage_target(_damage = damage):
	sound_manager.play("attack")
	if attack_check.is_colliding():
		#Damage all colliding objects
		for i in attack_check.get_collision_count():
			attack_check.get_collider(i).take_damage(_damage)
			
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
	respawn_enemies()
		
func cast_fireball():
	if not $Spells/Fireball.visible and $FireballCooldownTimer.is_stopped() and not fireball_restricted_states.has($StateMachine.current_state.name.to_lower()):
		$FireballCooldownTimer.start()
		$Spells/Fireball._activate(self, get_global_mouse_position())
		sound_manager.play("fireball")

func cast_frost():
	if $FrostCooldownTimer.is_stopped() and not frost_restricted_states.has($StateMachine.current_state.name.to_lower()):
		$FrostCooldownTimer.start()
		$Spells/Frost._activate(self, get_global_mouse_position())
		sound_manager.play("frost")
		
func cast_lightning_strike():
	var hit_an_enemy = false
	if is_lightning_strike_cooldown_done() and not lightning_strike_restricted_states.has($StateMachine.current_state.name.to_lower()):
		for enemy in get_tree().get_nodes_in_group("Enemies"):
				if enemy.is_on_screen and not enemy.dead:
					enemy.lightning_strike()
					hit_an_enemy = true
	if hit_an_enemy:
		start_lightning_strike_cooldown()
		sound_manager.play("lightning")
		
func can_dash() -> bool:
	return $DashCooldownTimer.is_stopped() and not dash_restricted_states.has($StateMachine.current_state.name.to_lower())
	
func dash():
	if can_dash():
		$DashCooldownTimer.start()
		$StateMachine.change_state("dash")
		
func use_melee_combo():
	if $MeleeComboCooldownTimer.is_stopped() and not melee_combo_restricted_states.has($StateMachine.current_state.name.to_lower()):
		$MeleeComboCooldownTimer.start()
		$StateMachine.change_state("melee_combo")

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
