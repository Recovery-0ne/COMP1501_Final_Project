extends PlayerState

func _enter():
	animation_name = "dash"
	super()
	print(player.direction)
	player.velocity.x = player.direction * 800 
	player.velocity.y = 0  
	
func _update(delta: float):
	super(delta)
	
	
func _physics_update(delta: float):
	super(delta)
	player.move()


func _exit():
	super()
	print('2')
func _animation_end():
	state_machine.change_state("move")
	print('3')
