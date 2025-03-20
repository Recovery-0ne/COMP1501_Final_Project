extends EnemyState

func _enter():
	animation_name = "walk"
	super()
	#Increase detection rate
	enemy.vision._high_detect_rate()
	enemy.default_speed *= enemy.pursuit_speed_multiplier
	enemy.speed = enemy.default_speed
	anim.speed_scale=0.4*enemy.pursuit_speed_multiplier
	
func _update(delta: float):
	super(delta)
	enemy.change_direction_to((enemy.player.position.x - enemy.position.x)/abs(enemy.player.position.x - enemy.position.x))
	enemy.set_move()
	enemy.change_facing_direction()
		
	#After colliding, have the enemy move forward for longer before attacking so that the ShapeCast overlaps the player more
	if enemy.attack_check.is_colliding() and (enemy.attack_check.global_position - enemy.player.position).length() <= 25:
		state_machine.change_state("attack")
	elif enemy._is_facing_wall() or enemy._is_on_ledge() or abs(enemy.attack_check.global_position.x - enemy.player.position.x) <= 25:
		state_machine.change_state("idle")
	
func _exit():
	super()
	enemy.vision._low_detect_rate()
	enemy.default_speed /= enemy.pursuit_speed_multiplier
	enemy.speed = enemy.default_speed
	anim.speed_scale = 1
	enemy.stop()

func _on_timer_timeout() -> void:
	return
	if enemy.dead or state_machine.current_state == enemy.states["attack"]: return
	state_machine.change_state("idle")
