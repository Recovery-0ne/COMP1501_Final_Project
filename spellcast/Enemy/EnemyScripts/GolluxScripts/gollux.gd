extends Enemy

var vision: BossVision

func _ready() -> void:
	super()
	vision = $Detector
	vision.body = self
	vision.target = player

func reset():
	health = max_health
	remove_all_status_conditions()
	update_health_display()
	
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
	if health < max_health * 0.25:
		$RockFall._activate()
	elif health < max_health * 0.5:
		if randi_range(1,2) == 1:
			$RockFall._activate()
	elif health < max_health * 0.75:
		if randi_range(1,4) == 1:
			$RockFall._activate()
	
func take_damage(_damage:int, _flinch:=true, _apply_frozen_multiplier:=true):
	super(_damage, _flinch, _apply_frozen_multiplier)
	if _flinch == true and $StateMachine.current_state != states["attack"] and $StateMachine.current_state != states["rock_throw"] and $StateMachine.current_state != states["damaged"]:
		$StateMachine.change_state("damaged")
	
func disable_functions_for_dead():
	vision.process_mode = Node.PROCESS_MODE_DISABLED
	attack_check.enabled = false
	floor_check.enabled = false
	wall_check.enabled = false
	set_collision_layer_value(2, false)

func can_use_rock_throw() -> bool:
	return $RockThrowCooldownTimer.is_stopped() and position.distance_to(player.position) <= 500 and position.distance_to(player.position) >= 200
	
func use_rock_throw():
	$RockThrowCooldownTimer.start()
	$StateMachine/Rock_Throw/RockThrow._activate(self, player.position)
	
func apply_freezing():
	if has_status_effect or dead: return
	speed *= 0.7
	anim.speed_scale = 0.7
	has_status_effect = true
	frozen = true
	status_effect_duration = freeze_slow_duration
	$StatusEffectTimer.wait_time = status_effect_duration
	$StatusEffectTimer.connect("timeout", end_frozen_effect)
	$StatusEffectTimer.start()
	$HPbar.update_status_effect_frozen(frozen)
		
func end_frozen_effect():
	if not frozen: return
	speed = default_speed
	anim.speed_scale = 1
	has_status_effect = false
	frozen = false
	$HPbar.update_status_effect_frozen(frozen)
	$StatusEffectTimer.disconnect("timeout", end_frozen_effect)
