extends EnemyState

func _enter():
	animation_name = "walk"
	super()
	#$SoundTimer.start()
	
func _update(delta:float):
	super(delta)
	
func _physics_update(delta:float):
	super(delta)
	enemy.change_direction_to_player()
	enemy.set_move()
	enemy.change_facing_direction()
		
	#After colliding, have the enemy move forward for longer before attacking so that the ShapeCast overlaps the player more
	if enemy.attack_check.is_colliding() and (enemy.attack_check.global_position - enemy.player.position).length() <= 70:
		state_machine.change_state("attack")
	elif enemy._is_facing_wall() or enemy._is_on_ledge() or not enemy.can_see_target or abs(enemy.position.x - enemy.player.position.x) <= 15:
		state_machine.change_state("idle")
	
func _exit():
	super()
	enemy.stop()
	#$SoundTimer.stop()

func _on_sound_timer_timeout() -> void:
	enemy.sound_manager.play("walk")
	$SoundTimer.start()
