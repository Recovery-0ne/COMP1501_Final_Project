extends Enemy

func flip_sprite():
	if velocity.x > 0:
		animated_sprite.flip_h = false
		animated_sprite.offset.x = 0
	elif  velocity.x < 0:
		animated_sprite.flip_h = true
		animated_sprite.offset.x = -8
