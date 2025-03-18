extends EnemyState

func _enter():
	animation_name = "idle"
	super()
	#Increase detection rate
	enemy.vision._high_detect_rate()
	enemy.speed *= enemy.pursuit_speed_multiplier
	anim.speed_scale=0.4*enemy.pursuit_speed_multiplier
	
func _update(delta: float):
	super(delta)
	enemy.change_direction_to((enemy.player.position.x - enemy.position.x)/abs(enemy.player.position.x - enemy.position.x))
	enemy.change_facing_direction()
	
	#Have the enemy able to track the player for a short duration after losing visual
	if enemy.can_see_target:
		$Timer.stop()
	elif not enemy.can_see_target and $Timer.is_stopped():
		$Timer.start()
		
	#After colliding, have the enemy move forward for longer before attacking so that the ShapeCast overlaps the player more
	if enemy.attack_check.is_colliding() and (enemy.attack_check.global_position - enemy.player.position).length() <= 15:
		state_machine.change_state("attack")
	elif enemy._is_facing_wall() or enemy._is_on_ledge():
		enemy.stop()
		anim.play("idle")
	else:
		enemy.set_move()
		anim.play("walk")
	
func _exit():
	super()
	enemy.vision._low_detect_rate()
	enemy.speed /= enemy.pursuit_speed_multiplier
	anim.speed_scale = 1
	enemy.stop()

func _on_timer_timeout() -> void:
	if enemy.dead or state_machine.current_state == enemy.states["attack"]: return
	if enemy._is_facing_wall() or enemy._is_on_ledge():
		enemy.change_direction()
	state_machine.change_state("idle")
