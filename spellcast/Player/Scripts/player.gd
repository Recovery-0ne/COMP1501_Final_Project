extends CharacterBody2D

class_name Player

var states: Dictionary
var direction:= 1
@export var max_health:= 100
@onready var health:= max_health
var damage:= 5
var speed:= 500
var gravity:= 65
var jump_velocity:= 1000
@onready var attack_check:= $AttackCheck
@export var checkpoint_position: Vector2

var dead = false

func _init() -> void:
	self.add_to_group("Player")

func _ready():
	global_position = checkpoint_position
	for state in $StateMachine.get_children():
		state.initialize($StateMachine, self, $Animations, state.name.to_lower())
		states[state.name.to_lower()] = state
	$StateMachine.initialize()
	update_health_display()

func apply_gravity():
	if not is_on_floor():
		velocity.y = clamp(velocity.y + gravity, -jump_velocity, 1.75*jump_velocity)
		
func move(multiplier:=1.0):
	velocity.x = direction * speed * multiplier
	move_and_slide()
		
func damage_target():
	if attack_check.is_colliding():
		#Damage all colliding objects
		for i in attack_check.get_collision_count():
			attack_check.get_collider(i).take_damage(damage)

func take_damage(_damage:int, _flinch:=true):
	if dead: return
	health = clamp(health - _damage, 0, max_health)
	if health == 0:
		dead = true
		$StateMachine.change_state("dead")
		$HealthLabel.visible = false
		# add signal that waits until death animation finishes:
		respawn_player()
	elif _flinch == true:
		$StateMachine.change_state("damaged")
	update_health_display()

func respawn_player():
	dead = false
	global_position = checkpoint_position
	$StateMachine.initialize()
	health = max_health
	$HealthLabel.visible = true
	
	
func update_health_display():
	$HealthLabel.text = str(health)
	
func cast_fireball():
	if not $StateMachine/Cast_Fireball/Fireball.visible and $StateMachine/Cast_Fireball/Cast_Timer.is_stopped():
		$StateMachine/Cast_Fireball/Cast_Timer.start()
		$StateMachine/Cast_Fireball/Fireball._activate(self, get_global_mouse_position())
