extends EnemyState

func _enter():
	animation_name = "run"
	super()
	enemy.default_speed *= enemy.pursuit_speed_multiplier
	enemy.speed = enemy.default_speed
	$SoundTimer.start()
	
func _update(delta: float):
	super(delta)
		
func _physics_update(delta: float):
	super(delta)
	enemy.change_direction_to_player()
	enemy.change_facing_direction_to_player()
		
	#After colliding, have the enemy move forward for longer before attacking so that the ShapeCast overlaps the player more
	if enemy.can_see_target and enemy.can_attack() and enemy.in_attack_range():
		state_machine.change_state("attack")
	elif enemy._is_facing_wall() or enemy._is_on_ledge() or enemy.in_attack_range():
		state_machine.change_state("idle")
	else:
		enemy.set_move()
	
func _exit():
	super()
	enemy.default_speed /= enemy.pursuit_speed_multiplier
	enemy.speed = enemy.default_speed
	enemy.stop()
	$SoundTimer.stop()

func _on_sound_timer_timeout() -> void:
	enemy.sound_manager.play("walk")
	$SoundTimer.start()
