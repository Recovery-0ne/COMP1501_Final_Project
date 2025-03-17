extends Node
class_name EnemyState

var state_machine: StateMachineEnemy
var enemy: Enemy
var animated_sprite: AnimatedSprite2D
var animation_name: String

func _initalize(_state_machine: StateMachineEnemy, _enemy: Enemy, _animated_sprite: AnimatedSprite2D, _animation_name: String):
	state_machine = _state_machine
	enemy = _enemy
	animated_sprite = _animated_sprite
	animation_name = _animation_name

func _enter():
	animated_sprite.play(animation_name)
	
func _update(delta: float):
	enemy.apply_gravity(delta)
	enemy.move_and_slide()
	
func _exit():
	pass
	
	
