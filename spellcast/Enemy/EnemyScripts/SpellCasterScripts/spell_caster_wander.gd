extends EnemyState

func _enter():
	animation_name = "walk"
	super()
	if enemy._is_facing_wall() or enemy._is_on_ledge():
		enemy.change_direction()
	enemy.set_move()
	enemy.change_facing_direction_to(enemy.move_dir)
	#Force the raycasts to update to make sure that if we turned away from any walls/ledges, the enemy knows immediately
	enemy.wall_check.force_raycast_update()
	enemy.floor_check.force_raycast_update()
	enemy.force_vision_update()
	$SoundTimer.start()
	
func _update(delta: float):
	super(delta)
		
func _physics_update(delta: float):
	super(delta)
	if enemy._is_facing_wall() or enemy._is_on_ledge() or enemy.can_see_target:
		state_machine.change_state("idle")
	else:
		enemy.set_move()
	
func _exit():
	super()
	enemy.stop()
	$SoundTimer.stop()

func _on_sound_timer_timeout() -> void:
	enemy.sound_manager.play("walk")
	$SoundTimer.start()
