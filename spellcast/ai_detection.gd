extends Node

@export var target : Node2D
@export var body : Node2D
@export var vision_range = 900
##Min = 0, Max = 1 (0 = 0 degrees, 1 = 90 degrees)
@export var Vision_cone_size = 0.4
signal see_target

func _on_timer_timeout() -> void:
	_vision_check()
	
func _vision_check():
	#Check is the target is in the vision range
	if body.global_position.distance_to(target.global_position) <= vision_range:
		#Get the dot product of the vector to the target and the facing direction
		#Normalize the vector to the target before calculating the dot product to ensure it is in the range of -1 to 1
		var dot = (target.global_position - body.global_position).normalized().dot(body.facing_dir)
		#Use the dot product to create a vision cone in front of the body with this detection system
		#Use 1-vision_cone_size so that when the variable is increased, the size of the cone also increases
		if 1-Vision_cone_size <= dot:
			#Raycast to check if things are blocking line of sight
			var space_state = body.get_world_2d().direct_space_state
			var sight_check = space_state.intersect_ray(PhysicsRayQueryParameters2D.create(body.position, target.position))
			#Was the raycast successful?
			if sight_check:
				#Is the hit object the target?
				if sight_check.collider.name == target.name:
					emit_signal("see_target")
