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
	player.direction = Input.get_axis("left", "right")
	if player.direction != 0:
		sprite.flip_h = player.direction < 0
		player.attack_check.position.x = abs(player.attack_check.position.x) * player.direction
		player.wall_check.target_position.x = abs(player.wall_check.target_position.x)*player.direction
		
	if Input.is_action_just_pressed("lightning") and player.is_lightning_strike_cooldown_done():
		for enemy in get_tree().get_nodes_in_group("Enemies"):
			if enemy.is_on_screen:
				enemy.lightning_strike()
				player.start_lightning_strike_cooldown()
	
func _physics_update(delta: float):
	player.apply_gravity()

func _exit():
	pass
	
	
	
