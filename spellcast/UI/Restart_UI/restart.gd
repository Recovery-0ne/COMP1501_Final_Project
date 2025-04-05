extends Node2D
@export var load_scene: PackedScene

func _ready():
	$Timer.start()
	$AudioStreamPlayer.play()
	$RichTextLabel.hide()
	$RichTextLabel2.hide()
	$Button.hide()

func _on_button_pressed():
	get_tree().change_scene_to_packed(load_scene)

func _on_timer_timeout():
	$RichTextLabel.show()
	$RichTextLabel2.show()
	$Button.show()
