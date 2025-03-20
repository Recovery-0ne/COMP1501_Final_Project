extends Node2D
var target: Entity
@export var damage:=10
@export var frozen_damage:=5

func enable():
	visible = true
	$Sprite2D/AnimationPlayer.play("default")

func do_damage():
	target.take_damage(damage)
	if target.frozen:
		target.end_frozen_effect() #This needs to go first to eliminate the increased defense
		target.take_damage(frozen_damage,false)
	elif target.has_status_effect == false:
		if randi_range(0,4) == 0:
			target.apply_burning()
	
func disable():
	visible = false
	$Sprite2D/AnimationPlayer.stop()
