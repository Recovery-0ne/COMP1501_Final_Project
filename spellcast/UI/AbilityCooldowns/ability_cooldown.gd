extends Node2D
@export var key:=""
@onready var progress_bar = $TextureProgressBar
@onready var color = $ColorRect.color
@onready var sprite_transform = $Sprite2D.transform
@onready var texture = $Sprite2D.texture
@onready var hframes = $Sprite2D.hframes
@onready var vframes = $Sprite2D.vframes
@onready var frame = $Sprite2D.frame

func _ready() -> void:
	if find_child("Label") != null:
		$Label.text = key

func set_icon(_color, _transform, _texture, _hframes, _vframes, _frame):
	$ColorRect.color = _color
	$Sprite2D.transform = _transform
	$Sprite2D.texture = _texture
	$Sprite2D.hframes = _hframes
	$Sprite2D.vframes = _vframes
	$Sprite2D.frame = _frame
	$Label.visible = true
	
func reset_to_default():
	$TextureProgressBar.value = 0
	$ColorRect.color = color
	$Sprite2D.transform = sprite_transform
	$Sprite2D.texture = texture
	$Sprite2D.hframes = hframes
	$Sprite2D.vframes = vframes
	$Sprite2D.frame = frame
	$Label.visible = false
