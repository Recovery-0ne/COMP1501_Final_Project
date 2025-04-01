extends Node2D
class_name BossVision

var target : Node2D
var body : Node2D
@export var vision_range = 700
@onready var default_timer_time = $Timer.wait_time

var in_range = false

func _ready() -> void:
	scale /= global_scale

func _on_timer_timeout() -> void:
	body.can_see_target = _can_see_target()
	
func _high_detect_rate():
	$Timer.wait_time = default_timer_time/5
	
func _low_detect_rate():
	$Timer.wait_time = default_timer_time
	
func _can_see_target():
	#Check is the target is in the vision range
	if body.global_position.distance_to(target.global_position) <= vision_range:
		in_range = true
		_high_detect_rate()
		#Use ray cast to check if things are blocking line of sight
		#Set the ray cast to point towards the player
		$RayCast2D.target_position = target.global_position - global_position
		#Is the hit object the target?
		if $RayCast2D.is_colliding():
			if $RayCast2D.get_collider() == target:
				#The player has been seen
				return true
	else:
		in_range = false
		_low_detect_rate()
	return false
