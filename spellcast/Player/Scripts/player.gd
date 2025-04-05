extends Entity
class_name Player

@export var checkpoint_position: Vector2
var direction:= 1
var wall_check
var jump_count = 0
var max_jumps = 2

var player_money = 0
var camera : Camera2D

@export var default_mana:=100.0
@onready var mana:=default_mana

#Store all names of abilities
var ability_names := ["Fireball", "Frost", "MeleeCombo", "LightningStrike", "MedicalMalarkey"] 
#Store all names of unlocked abilities. Empty string represents no ability
var available_abilities := [""] 
#Store method names of all abilites (indices should match the names array)
var ability_methods := ["cast_fireball", "cast_frost", "use_melee_combo", "cast_lightning_strike", "use_medical_malarkey"] 
#Store method names of the currently equipped abilities
var current_ability_methods := ["", "", "", ""] 

#Make a dictionary for all the descriptions of the player's abilities
var ability_descriptions = {"Fireball":"Cast a fireball in the direction of your cursor. Deals little damage on hit, but has a 100% chance to apply burning to the opponent.", 
							"Frost":"Cast a ball of ice in the direction of your cursor. Deals little damage on hit, but has a 100% chance to apply freezing to the opponent.",
							"MeleeCombo":"Strike the opponent with a series of 3 hits",
							"LightningStrike":"Strike all opponents on the screen with a bolt of lightning. If the target is frozen, deal 50% more damage and remove the frozen effect. Otherwise, deal base damage with a 25% chance to apply burning.",
							"MedicalMalarkey":"Heal yourself a small amount"
							}

#Store prices of all the abilities
var ability_prices = {"Fireball":50,"Frost":50,"MeleeCombo":80,"LightningStrike":150,"MedicalMalarkey":100}
var ability_unlock_levels = {"Fireball":1,"Frost":1,"MeleeCombo":2,"LightningStrike":3,"MedicalMalarkey":3}

#Store the names of states that each ability can't be used in
var dash_restricted_states := ["attack", "air_attack", "move_attack", "dead", "wall_slide", "wall_climb"]
var fireball_restricted_states := ["attack", "air_attack", "move_attack", "dead", "wall_slide", "wall_climb"]
var frost_restricted_states := ["attack", "air_attack", "move_attack", "dead", "wall_slide", "wall_climb"]
var lightning_strike_restricted_states := ["attack", "air_attack", "move_attack", "dead", "wall_slide", "wall_climb"]
var melee_combo_restricted_states := ["attack", "air_attack", "move_attack", "dead", "wall_slide", "wall_climb", "dash", "jump", "wall_jump", "fall"]
var medical_malarkey_restricted_states := ["dead"]

func _init() -> void:
	self.add_to_group("Player")

func _ready():
	camera = $Camera2D
	facing_dir = direction
	checkpoint_position = global_position
	wall_check = $WallCheck
	for state in $StateMachine.get_children():
		state._initialize($StateMachine, self, sprite, anim, state.name.to_lower())
		states[state.name.to_lower()] = state
	$StateMachine._initialize()
	update_health_display()

func set_money(amount):
	player_money = amount
	var ui = get_tree().get_first_node_in_group("In_Game_UI")
	if ui == null: return
	ui.find_child("PlayerMoney").text = "Money: "+str(player_money)
	ui = get_tree().get_first_node_in_group("Shop_UI")
	ui.find_child("PlayerMoney").text = "Money: "+str(player_money)
	
func update_mana_bar():
	$ManaBar.value = (mana / default_mana) * 100

func flip_to(dir:int):
	facing_dir = dir
	sprite.flip_h = dir < 0
	attack_check.position.x = abs(attack_check.position.x) * dir
	wall_check.target_position.x = abs(wall_check.target_position.x) * dir
		
func move(multiplier:=1.0):
	velocity.x = direction * speed * multiplier
	move_and_slide()
  
func damage_target():
	sound_manager.play("attack")
	if attack_check.is_colliding():
		mana = clamp(mana + 5, 0, default_mana)
		update_mana_bar()
		#Damage all colliding objects
		for i in attack_check.get_collision_count():
			if (attack_check.get_collider(i) is Enemy):
				attack_check.get_collider(i).take_damage(damage)
			else:
				var collider = attack_check.get_collider(i)
				collider.get_parent().open_chest()
			
func take_damage(_damage:int, _flinch:=true, _apply_frozen_multiplier:=true):
	super(_damage, _flinch, _apply_frozen_multiplier)
	if _flinch and $StateMachine.current_state == states["idle"]:
		$StateMachine.change_state("damaged")
		
func decrease_health(_damage: int):
	super(_damage)
	if health == 0:
		$ManaBar.visible = false
		
func respawn_player():
	remove_all_status_conditions()
	dead = false
	global_position = checkpoint_position
	health = max_health
	$StateMachine._initialize()
	update_health_display()
	$HPbar.visible = true
	$ManaBar.visible = true
	respawn_enemies()
	
	#This is needed so that is_on_floor() returns false and the player will fall to the ground
	velocity.y = 10
	move_and_slide()
		
func cast_fireball():
	var mana_cost = 5
	if mana >= mana_cost and $FireballCooldownTimer.is_stopped() and not fireball_restricted_states.has($StateMachine.current_state.name.to_lower()):
		$FireballCooldownTimer.start()
		$Spells/Fireball._activate(self, get_global_mouse_position())
		sound_manager.play("fireball")
		mana -= mana_cost

func cast_frost():
	var mana_cost = 10
	if mana >= mana_cost and $FrostCooldownTimer.is_stopped() and not frost_restricted_states.has($StateMachine.current_state.name.to_lower()):
		$FrostCooldownTimer.start()
		$Spells/Frost._activate(self, get_global_mouse_position())
		sound_manager.play("frost")
		mana -= mana_cost
		
func cast_lightning_strike():
	var hit_an_enemy = false
	var mana_cost = 25
	if mana >= mana_cost and $LightningStrikeCooldownTimer.is_stopped() and not lightning_strike_restricted_states.has($StateMachine.current_state.name.to_lower()):
		for enemy in get_tree().get_nodes_in_group("Enemies"):
			if enemy.is_on_screen and not enemy.dead:
				enemy.lightning_strike()
				hit_an_enemy = true
		if hit_an_enemy:
			mana -= mana_cost
			$LightningStrikeCooldownTimer.start()
			sound_manager.play("lightning")
		
func can_dash() -> bool:
	return $DashCooldownTimer.is_stopped() and not dash_restricted_states.has($StateMachine.current_state.name.to_lower())
	
func dash():
	if can_dash():
		$StateMachine.change_state("dash")
		
func start_dash_cooldown_timer():
	$DashCooldownTimer.start()
		
func use_melee_combo():
	var mana_cost = 15
	if mana >= mana_cost and $MeleeComboCooldownTimer.is_stopped() and not melee_combo_restricted_states.has($StateMachine.current_state.name.to_lower()):
		$StateMachine.change_state("melee_combo")
		mana -= mana_cost
		
func start_melee_combo_cooldown_timer():
	$MeleeComboCooldownTimer.start()
	
func use_medical_malarkey():
	var mana_cost = 20
	if mana >= mana_cost and $MedicalMalarkeyCooldownTimer.is_stopped() and not medical_malarkey_restricted_states.has($StateMachine.current_state.name.to_lower()):
		health = clamp(health + 10, 0, max_health)
		$MedicalMalarkeyCooldownTimer.start()
		update_health_display()
		sound_manager.play("heal")
		mana -= mana_cost

func use_ability(ability_num:int):
	if current_ability_methods[ability_num - 1] != "":
		call(current_ability_methods[ability_num - 1])
		update_mana_bar()
		
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
