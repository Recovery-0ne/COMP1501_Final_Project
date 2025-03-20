extends Node2D

var target : Node2D
var body : Node2D
@export var vision_range = 700
##Min = 0, Max = 1 (0 = 0 degrees, 1 = 90 degrees)
@export var Vision_cone_size = 0.4
@onready var default_timer_time = $Timer.wait_time

func _ready() -> void:
	scale /= global_scale

func _on_timer_timeout() -> void:
	body.can_see_target = _can_see_target()
	
func _high_detect_rate():
	$Timer.wait_time = default_timer_time/2
	
func _low_detect_rate():
	$Timer.wait_time = default_timer_time
	
func _can_see_target():
	#Check is the target is in the vision range
	if body.global_position.distance_to(target.global_position) <= vision_range:
		#Get the dot product of the vector to the target and the facing direction
		#Normalize the vector to the target before calculating the dot product to ensure it is in the range of -1 to 1
		var dot = (target.global_position - body.global_position).normalized().dot(Vector2(body.facing_dir,0))
		#Use the dot product to create a vision cone in front of the body with this detection system
		#Use 1-vision_cone_size so that when the variable is increased, the size of the cone also increases
		if 1-Vision_cone_size <= dot:
			#Use ray cast to check if things are blocking line of sight
			#Set the ray cast to point towards the player
			$RayCast2D.target_position = target.global_position - global_position
			#Enable the raycast
			$RayCast2D.enabled = true
			#Is the hit object the target?
			if $RayCast2D.is_colliding():
				if $RayCast2D.get_collider() == target:
					#Disable the ray cast to save procesing power
					$RayCast2D.enabled = false
					#The player has been seen
					return true
	return false
