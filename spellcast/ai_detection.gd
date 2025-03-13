extends Node

@export var target : Node2D
@export var body : Node2D
@export var vision_range = 900
@export var Vision_cone_size = 0.4
var facing_dir = Vector2(1,0)
signal see_target

func _on_timer_timeout() -> void:
	_vision_check()
	
func _vision_check():
	if body.global_position.distance_to(target.global_position) <= vision_range:
		var dot = (target.global_position - body.global_position).normalized().dot(facing_dir)
		if 1-Vision_cone_size <= dot and dot <= 1:
			#Raycast to check if things are blocking line of sight
			var space_state = body.get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(body.position, target.position)
			var sight_check = space_state.intersect_ray(query)
			if sight_check:
				if sight_check.collider.name == target.name:
					emit_signal("see_target")
