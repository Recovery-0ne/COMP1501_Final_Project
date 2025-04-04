extends Camera2D
@export var random_strength = 20.0
@export var shake_fade = 5.0

var shake_strength = 0

func shake():
	shake_strength = random_strength

func _process(delta: float) -> void:
	if shake_strength >= 0:
		shake_strength = lerpf(shake_strength,0,shake_fade * delta)
		offset = random_offset()
	
func random_offset() -> Vector2:
	return Vector2(randf_range(-shake_strength, shake_strength),randf_range(-shake_strength, shake_strength))
