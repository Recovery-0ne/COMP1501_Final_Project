extends Node
class_name EnemyState

var state_machine: StateMachineEnemy
var enemy: Enemy
var sprite: Sprite2D
var anim: AnimationPlayer
var animation_name: String

func _initialize(_state_machine: StateMachineEnemy, _enemy: Enemy, _sprite: Sprite2D, _anim: AnimationPlayer, _animation_name: String):
	state_machine = _state_machine
	enemy = _enemy
	sprite = _sprite
	anim = _anim
	animation_name = _animation_name

func _enter():
	anim.play(animation_name)
	
func _physics_update(delta: float):
	enemy.apply_gravity()
	enemy.move_and_slide()
	
func _update(delta: float):
	pass
	
func _exit():
	pass
	
	
