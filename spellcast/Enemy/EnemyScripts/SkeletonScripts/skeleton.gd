extends Enemy
	
func set_move():
	velocity.x = move_dir * speed
	
func stop():
	velocity.x = 0

func change_facing_direction():
	if velocity.x > 0:
		facing_dir = 1
		sprite.flip_h = false
		sprite.offset.x = abs(sprite.offset.x)
		attack_check.position.x = abs(attack_check.position.x)
	elif  velocity.x < 0:
		facing_dir = -1
		sprite.flip_h = true
		sprite.offset.x = -abs(sprite.offset.x)
		attack_check.position.x = -abs(attack_check.position.x)
