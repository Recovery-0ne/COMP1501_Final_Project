extends Node

class_name PlayerState

var state_machine: StateMachine
var player: Player
var anim2D: AnimatedSprite2D
var animation_name: String

func initialize(_state_machine: StateMachine, _player: Player, _anim2D: AnimatedSprite2D, _animation_name: String):
	state_machine = _state_machine
	player = _player
	anim2D = _anim2D
	animation_name = _animation_name

func _enter():
	anim2D.play(animation_name)

func _update(delta: float): #Write code here that should be used in every state only.
	player.direction = Input.get_axis("left", "right")
	if player.direction != 0:
		anim2D.flip_h = player.direction < 0
	player.apply_gravity()

func _exit():
	pass
	
	
	
