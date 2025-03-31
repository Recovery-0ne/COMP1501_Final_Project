extends Node2D
class_name Vision

var target : Node2D
var body : Node2D
@export var vision_range = 700
##Min = 0, Max = 1 (0 = 0 degrees, 1 = 90 degrees)
@export var Vision_cone_size = 0.6
@onready var default_timer_time = $Timer.wait_time

var in_range = false
var in_vision_cone = false

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
		#Get the dot product of the vector to the target and the facing direction
		#Normalize the vector to the target before calculating the dot product to ensure it has a length of 1
		var dot = (target.global_position - body.global_position).normalized().dot(Vector2(body.facing_dir,0))
		#Use the dot product to create a vision cone in front of the body with this detection system
		#Use 1-vision_cone_size so that when the variable is increased, the size of the cone also increases
		if 1-Vision_cone_size <= dot:
			#Use ray cast to check if things are blocking line of sight
			#Set the ray cast to point towards the player
			$RayCast2D.target_position = target.global_position - global_position
			#Is the hit object the target?
			if $RayCast2D.is_colliding():
				if $RayCast2D.get_collider() == target:
					#The player has been seen
					return true
		else:
			in_vision_cone = false
	else:
		in_range = false
		in_vision_cone = false
		_low_detect_rate()
	return false
