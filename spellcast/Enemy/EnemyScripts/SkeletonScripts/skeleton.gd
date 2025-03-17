extends Enemy
	
func set_move():
	velocity.x = move_dir * speed
	
func stop():
	velocity.x = 0

func change_facing_direction():
	if velocity.x > 0:
		facing_dir = 1
		animated_sprite.flip_h = false
		animated_sprite.offset.x = abs(animated_sprite.offset.x)
		attack_check.position.x = abs(attack_check.position.x)
	elif  velocity.x < 0:
		facing_dir = -1
		animated_sprite.flip_h = true
		animated_sprite.offset.x = -abs(animated_sprite.offset.x)
		attack_check.position.x = -abs(attack_check.position.x)
