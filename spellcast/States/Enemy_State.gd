extends Node
class_name EnemyState

var state_machine: StateMachineEnemy
var enemy: Enemy
var animation_player: AnimatedSprite2D
var animation_name: String

func initalize(_state_machine: StateMachineEnemy, _enemy: Enemy, _animation_player: AnimatedSprite2D, _animation_name: String):
	state_machine = _state_machine
	enemy = _enemy
	animation_player = _animation_player
	animation_name = _animation_name
	

func enter():
	animation_player.play(animation_name)
	
func exit():
	pass
	
func update(delta: float):
	enemy.apply_gravity(delta)
	enemy.move_and_slide()
	
	
