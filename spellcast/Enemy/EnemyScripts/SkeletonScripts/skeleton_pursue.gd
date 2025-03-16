extends EnemyState

@export var speed_scale = 2

func _enter():
	animation_name = "walk"
	super()
	#Increase detection rate
	enemy.vision._high_detect_rate()
	enemy.speed *= speed_scale
	
func _update(delta: float):
	super(delta)
	enemy.change_direction_to((enemy.player.position.x - enemy.position.x)/abs(enemy.player.position.x - enemy.position.x))
	enemy.change_facing_direction()
	enemy.set_move()
	if not enemy.can_see_target:
		state_machine.change_state("idle")
	if enemy.attack_check.is_colliding():
		#After colliding, have the enemy move forward for longer before attacking so that the RayShape overlaps the player more
		if (enemy.position - enemy.player.position).length() <= 50:
			state_machine.change_state("attack")
	
func _exit():
	super()
	enemy.vision._low_detect_rate()
	enemy.speed /= speed_scale
	enemy.stop()
