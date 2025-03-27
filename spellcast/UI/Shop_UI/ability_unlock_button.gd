extends TextureButton

func _on_button_up() -> void:
	if $Label.text != "NULL":
		get_tree().get_first_node_in_group("Shop_UI").buy_ability(name)
	disabled = true
