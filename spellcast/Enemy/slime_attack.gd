extends EnemyState

var can_attack := false
var has_hit_player := false

func _enter():
	animation_name = "jump_start_up"
	super()
	
func _update(delta: float):
	super(delta)
	
func _physics_update(delta: float):
	super(delta)
	if (can_attack and enemy.attack_check.is_colliding() and not has_hit_player):
		enemy.damage_target()
		has_hit_player = true
	elif (can_attack and enemy.is_on_floor()):
		can_attack = false 
		enemy.velocity = Vector2.ZERO
		anim.play("jump_land")
	
	
func _exit():
	has_hit_player = false
	super()
	
func slime_jump():
	print("slime be jumpin")
	enemy.velocity = Vector2(400 * enemy.facing_dir, -enemy.jump_velocity)
	
func prepare_animation_finished():
	can_attack = true 
	anim.play("attack")
	
func land_animation_finished():
	state_machine.change_state("pursue")
