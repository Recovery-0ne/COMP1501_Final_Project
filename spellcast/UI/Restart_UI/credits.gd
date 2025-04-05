extends Label

var speed = 50

func _ready():
	position.y = -size.y

func _process(delta):
	position.y += speed * delta 


	if position.y >= get_viewport_rect().size.y:
		queue_free()
