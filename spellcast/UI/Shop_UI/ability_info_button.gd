extends Button

func set_icon(_color, _transform, _texture, _hframes, _vframes, _frame):
	$ColorRect.color = _color
	$Sprite2D.transform = _transform
	$Sprite2D.position.x += 32
	$Sprite2D.position.y += 32
	$Sprite2D.texture = _texture
	$Sprite2D.hframes = _hframes
	$Sprite2D.vframes = _vframes
	$Sprite2D.frame = _frame
	
func set_locked(_locked:bool):
	$LockedColour.visible = _locked

func _on_button_up() -> void:
	get_tree().get_first_node_in_group("Shop_UI").popup(name)
