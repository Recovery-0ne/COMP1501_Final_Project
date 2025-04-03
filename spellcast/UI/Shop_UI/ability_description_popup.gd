extends ColorRect
@onready var UI = get_tree().get_first_node_in_group("Shop_UI")

func set_popup(ability_name:String, ability_description:String, ability_price:int):
	$VBoxContainer/Name.text = ability_name
	$VBoxContainer/Price.text = str(ability_price)
	$VBoxContainer/Description.text = ability_description
	$Button.disabled = UI.player.available_abilities.has(ability_name) or UI.player.ability_unlock_levels[ability_name] > UI.checkpoint_level
	
func deactivate():
	visible = false
	$Button.disabled = true

func _on_button_button_up() -> void:
	if UI.player.player_money >= UI.player.ability_prices[$VBoxContainer/Name.text]:
		$BuySound.play()
		UI.player.set_money(UI.player.player_money - UI.player.ability_prices[$VBoxContainer/Name.text])
		UI.buy_ability($VBoxContainer/Name.text)
		$Button.disabled = true
	else:
		$BuyError.play()
