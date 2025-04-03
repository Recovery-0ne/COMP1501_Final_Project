extends Enemy

var vision: BossVision

func _ready() -> void:
	super()
	vision = $Detector
	vision.body = self
	vision.target = player
	
func force_vision_update():
	can_see_target = vision._can_see_target()
	
func set_move():
	velocity.x = move_dir * speed
	
func stop():
	velocity.x = 0

func change_facing_direction():
	if velocity.x != 0:
		facing_dir = move_dir
		sprite.flip_h = move_dir < 0
		sprite.offset = sprite_offset[move_dir]
		attack_check.position.x = abs(attack_check.position.x) * move_dir

func flip_facing_direction():
	move_dir *= -1
	facing_dir = move_dir
	sprite.flip_h = move_dir < 0
	sprite.offset = sprite_offset[move_dir]
	attack_check.position.x = abs(attack_check.position.x) * move_dir
	flip_checks()
	
func damage_target():
	super()
	player.camera.shake()
	
func disable_functions_for_dead():
	vision.process_mode = Node.PROCESS_MODE_DISABLED
	attack_check.enabled = false
	floor_check.enabled = false
	wall_check.enabled = false
	set_collision_layer_value(2, false)
