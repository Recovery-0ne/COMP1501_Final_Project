extends CharacterBody2D
class_name Entity

var states: Dictionary

@onready var anim:= $Sprite2D/AnimationPlayer
@onready var sprite:= $Sprite2D
@onready var attack_check:= $AttackCheck

@export var max_health:= 100
@onready var health:= max_health
@export var default_damage:= 5
@onready var damage = default_damage
@export var default_speed:= 15
@onready var speed:= default_speed
@export var default_gravity:= 65
@onready var gravity:= default_gravity
@export var default_jump_velocity:= 1000
@onready var jump_velocity:= default_jump_velocity

var facing_dir:int

var has_status_effect:= false
var status_effect_duration:float #Depending on the effect, this could be a max number of occurances or a time

##Index 0 = minimum duration, Index 1 = maximum duration
@export var burn_effect_duration=[0,10]
var burning = false
##Time in seconds a frozen entity will be frozen for
@export var freeze_slow_duration:=5.0
var frozen = false

var dead:= false
	
func apply_gravity():
	if not is_on_floor():
		velocity.y = clamp(velocity.y + gravity, -jump_velocity, 1.75*jump_velocity)
		
func decrease_health(_damage: int):
	health = clamp(health - _damage, 0, max_health)
	update_health_display()
	if health == 0:
		end_frozen_effect()
		$StateMachine.change_state("dead")
		$HealthLabel.visible = false
		dead = true

func take_damage(_damage:int, _flinch:=true, _apply_frozen_multiplier:=true):
	if frozen and _apply_frozen_multiplier: _damage = _damage/2
	decrease_health(_damage)
	if _flinch: flinch()
	
func flinch():pass #Define this for each entity in their own script
		
func update_health_display():
	$HealthLabel.text = str(health)
		
func apply_effect(function_name:String):
	call(function_name)
		
func apply_burning():
	if has_status_effect or dead: return
	has_status_effect = true
	burning = true
	status_effect_duration = randi_range(burn_effect_duration[0],burn_effect_duration[1])
	$StatusEffectTimer.wait_time = 1
	$StatusEffectTimer.connect("timeout", take_burn_damage)
	$StatusEffectTimer.start()
	
func take_burn_damage():
	status_effect_duration -= 1
	if status_effect_duration >= 0:
		decrease_health(1)
		$StatusEffectTimer.start()
	else:
		end_burning_effect()
		
func end_burning_effect():
	has_status_effect = false
	burning = false
	$StatusEffectTimer.disconnect("timeout", take_burn_damage)
			
func apply_freezing():
	if has_status_effect or dead: return
	speed = 0
	anim.speed_scale = 0
	has_status_effect = true
	frozen = true
	status_effect_duration = freeze_slow_duration
	$StatusEffectTimer.wait_time = status_effect_duration
	$StatusEffectTimer.connect("timeout", end_frozen_effect)
	$StatusEffectTimer.start()
		
func end_frozen_effect():
	if not frozen: return
	speed = default_speed
	anim.speed_scale = 1
	has_status_effect = false
	frozen = false
	$StatusEffectTimer.disconnect("timeout", end_frozen_effect)
	
func lightning_strike():
	if dead: return
	$LightningStrike.enable()
	
func is_lightning_strike_cooldown_done():
	return $LightningStrikeCooldownTimer.is_stopped()
	
func start_lightning_strike_cooldown():
	$LightningStrikeCooldownTimer.start()
	
func remove_all_status_conditions():
	if not has_status_effect: return
	if burning: end_burning_effect()
	elif frozen: end_frozen_effect()
