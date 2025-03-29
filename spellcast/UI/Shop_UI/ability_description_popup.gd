extends ColorRect
@onready var UI = get_tree().get_first_node_in_group("Shop_UI")

func set_popup(ability_name:String, ability_description:String):
	$VBoxContainer/Name.text = ability_name
	$VBoxContainer/Description.text = ability_description
	$Button.disabled = UI.player.available_abilities.has(ability_name)
	
func deactivate():
	visible = false
	$Button.disabled = true

func _on_button_button_up() -> void:
	UI.buy_ability($VBoxContainer/Name.text)
	$Button.disabled = true
