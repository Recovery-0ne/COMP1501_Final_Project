extends EnemyState

func _enter():
	animation_name = "idle"
	super()
	enemy.default_speed *= enemy.pursuit_speed_multiplier
	enemy.speed = enemy.default_speed
	anim.speed_scale=0.4*enemy.pursuit_speed_multiplier
	
func _update(delta: float):
	super(delta)
		
func _physics_update(delta: float):
	super(delta)
	enemy.change_direction_to_player()
	enemy.set_move()
	enemy.change_facing_direction()
		
	if abs(enemy.position.x - enemy.player.position.x) < 75:
		state_machine.change_state("attack")
	elif enemy.position.distance_to(enemy.player.position) < 50 and not enemy.vision.in_vision_cone:
		state_machine.change_state("look_around")
	elif enemy._is_facing_wall() or enemy._is_on_ledge():
		state_machine.change_state("idle")
	
	
func _exit():
	super()
	enemy.default_speed /= enemy.pursuit_speed_multiplier
	enemy.speed = enemy.default_speed
	anim.speed_scale = 1
	enemy.stop()
