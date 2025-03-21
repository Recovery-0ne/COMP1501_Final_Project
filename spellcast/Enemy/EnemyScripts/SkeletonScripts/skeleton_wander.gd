extends EnemyState
var f = 0

func _enter():
	animation_name = "walk"
	super()
	if enemy._is_facing_wall() or enemy._is_on_ledge():
		enemy.change_direction()
	enemy.set_move()
	enemy.change_facing_direction()
	#Force the raycasts to update so that the update function won't immediately transition the enemy back to idle
	enemy.wall_check.force_raycast_update()
	enemy.floor_check.force_raycast_update()
	
func _update(delta: float):
	super(delta)
		
func _physics_update(delta: float):
	super(delta)
	enemy.set_move()
	if enemy._is_facing_wall() or enemy._is_on_ledge():
		state_machine.change_state("idle")
	elif enemy.can_see_target:
		state_machine.change_state("pursue")
	
func _exit():
	super()
	enemy.stop()
