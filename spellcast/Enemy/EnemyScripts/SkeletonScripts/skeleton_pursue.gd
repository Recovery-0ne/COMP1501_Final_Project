extends EnemyState

func _enter():
	animation_name = "walk"
	super()
	enemy.default_speed *= enemy.pursuit_speed_multiplier
	enemy.speed = enemy.default_speed
	anim.speed_scale = 0.4 * enemy.pursuit_speed_multiplier
	$SoundTimer.start()
	
func _update(delta: float):
	super(delta)
		
func _physics_update(delta: float):
	super(delta)
	enemy.change_direction_to_player()
	enemy.set_move()
	enemy.change_facing_direction()
		
	#After colliding, have the enemy move forward for longer before attacking so that the ShapeCast overlaps the player more
	if enemy.attack_check.is_colliding() and (enemy.attack_check.global_position - enemy.player.position).length() <= 25:
		state_machine.change_state("attack")
	elif enemy._is_facing_wall() or enemy._is_on_ledge() or abs(enemy.position.x - enemy.player.position.x) <= 15:
		state_machine.change_state("idle")
	elif not enemy.can_see_target:
		state_machine.change_state("look_around")
	
func _exit():
	super()
	enemy.default_speed /= enemy.pursuit_speed_multiplier
	enemy.speed = enemy.default_speed
	anim.speed_scale = 1
	enemy.stop()
	$SoundTimer.stop()

func _on_sound_timer_timeout() -> void:
	enemy.sound_manager.play("walk")
	$SoundTimer.start()
