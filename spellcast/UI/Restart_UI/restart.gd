extends CanvasLayer
@export var load_scene: PackedScene
var move = false

func _ready():
	$AudioStreamPlayer.play()
	$ColorRect/AnimationPlayer.play("fade_in")
	
func _physics_process(delta: float) -> void:
	if move:
		$Control.position.y -= 100 * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	get_tree().change_scene_to_packed(load_scene)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	move = true
