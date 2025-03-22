extends Enemy

@export var attack_range:=400
@onready var attack_cooldown_timer = $AttackCooldown
	
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
	
func can_attack():
	if attack_cooldown_timer.is_stopped():
		for spell in $StateMachine/Attack.get_children():
			if not spell.visible: return true
	return false
