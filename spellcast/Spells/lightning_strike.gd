extends Node2D
var target: Entity
@export var damage:=10
@export var frozen_damage:=5

func enable():
	visible = true
	$Sprite2D/AnimationPlayer.play("default")

func do_damage():
	if target.frozen:
		target.end_frozen_effect()
		target.take_damage(damage+frozen_damage, true, false)
	elif target.has_status_effect == false:
		if randi_range(0,4) == 0:
			target.apply_burning()
		target.take_damage(damage, true, false)
	else:
		target.take_damage(damage, true, false)
		
	
	
func disable():
	visible = false
	$Sprite2D/AnimationPlayer.stop()
