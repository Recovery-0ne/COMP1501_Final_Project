extends Node
@export var number_of_rocks := 8

func _ready() -> void:
	for i in range(0,number_of_rocks):
		add_child(load("res://Spells/FallingRock.tscn").instantiate())

func _activate():
	for rock in get_children():
		rock._activate()
