extends Node

class_name PlayerState

var state_machine: StateMachine
var player: Player
var sprite: Sprite2D
var anim: AnimationPlayer
var animation_name: String
var timer:Timer


func _initialize(_state_machine: StateMachine, _player: Player, _sprite: Sprite2D, _anim: AnimationPlayer, _animation_name: String):
	state_machine = _state_machine
	player = _player
	sprite = _sprite
	anim = _anim
	animation_name = _animation_name

func _enter():
	anim.play(animation_name)

func _update(delta: float): #Write code here that should be used in every state only.
	if player.frozen or player.dead: return 
	
	player.direction = Input.get_axis("left", "right")
	if player.direction != 0:
		player.flip_to(player.direction)
		
	#Get ability input and call appropriate method
	#Abilities will only be called when in states that are not included in their restriced states array
	if Input.is_action_just_pressed("ability_1"):
		player.use_ability(1)
	elif Input.is_action_just_pressed("ability_2"):
		player.use_ability(2)
	elif Input.is_action_just_pressed("ability_3"):
		player.use_ability(3)
	elif Input.is_action_just_pressed("ability_4"):
		player.use_ability(4)
	elif Input.is_action_just_pressed("dash"):
		player.dash()
	
func _physics_update(delta: float):
	player.apply_gravity()

func _exit():
	pass
	
	
	
