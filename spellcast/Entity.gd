extends CharacterBody2D
class_name Entity

var states: Dictionary

@onready var anim:= $Sprite2D/AnimationPlayer
@onready var sprite:= $Sprite2D
@onready var attack_check:= $AttackCheck

@export var max_health:= 100
@onready var health:= max_health
@export var damage:= 5
@export var speed:= 15
@export var gravity:= 35
@onready var jump_velocity:= gravity*gravity

var has_status_effect:= false
var status_effect_duration:float #Depending on the effect, this could be a max number of occurances or a time

##Index 0 = minimum duration, Index 1 = maximum duration
@export var burn_effect_duration=[0,10]

var dead:= false
	
func apply_gravity():
	if not is_on_floor():
		velocity.y = clamp(velocity.y + gravity, -jump_velocity, 1.75*jump_velocity)
		
func take_damage(_damage:int, _flinch:=true):
	if dead: return
	health = clamp(health - _damage, 0, max_health)
	update_health_display()
		
func update_health_display():
	$HealthLabel.text = str(health)
	
func cast_fireball():
	if not $StateMachine/Cast_Fireball/Fireball.visible and $StateMachine/Cast_Fireball/Cast_Timer.is_stopped():
		$StateMachine/Cast_Fireball/Cast_Timer.start()
		$StateMachine/Cast_Fireball/Fireball._activate(self, get_global_mouse_position())
		
func apply_burning():
	if has_status_effect: return
	has_status_effect = true
	status_effect_duration = randi_range(burn_effect_duration[0],burn_effect_duration[1])
	print_debug(status_effect_duration)
	$StatusEffectTimer.wait_time = 1
	$StatusEffectTimer.connect("timeout", take_burn_damage)
	$StatusEffectTimer.start()
	
func take_burn_damage():
	status_effect_duration -= 1
	if status_effect_duration >= 0:
		take_damage(1, false)
		$StatusEffectTimer.start()
	else:
		has_status_effect = false
		$StatusEffectTimer.disconnect("timeout", take_burn_damage)
