extends EnemyState

func _enter():
	animation_name = "run"
	super()
	enemy.default_speed *= enemy.pursuit_speed_multiplier
	enemy.speed = enemy.default_speed
	
func _update(delta: float):
	super(delta)
		
func _physics_update(delta: float):
	super(delta)
	enemy.change_direction_to_player()
	enemy.set_move()
	enemy.change_facing_direction()
		
	#After colliding, have the enemy move forward for longer before attacking so that the ShapeCast overlaps the player more
	if enemy.can_see_target and enemy.position.distance_to(enemy.player.position) < enemy.attack_range:
		state_machine.change_state("attack")
	elif enemy.position.distance_to(enemy.player.position) < 50 and not enemy.vision.in_vision_cone:
		state_machine.change_state("look_around")
	elif enemy._is_facing_wall() or enemy._is_on_ledge():
		state_machine.change_state("idle")
	
func _exit():
	super()
	enemy.default_speed /= enemy.pursuit_speed_multiplier
	enemy.speed = enemy.default_speed
	enemy.stop()
