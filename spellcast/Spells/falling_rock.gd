extends Area2D
@export var custom_gravity:float
var velocity : Vector2
var on_screen

func _ready() -> void:
	_deactivate()

func _activate():
	if visible: return
	velocity = Vector2(0,randf_range(0,500))
	position.y = -get_viewport_rect().size.y - randf_range(25,60)
	position.x = randf_range(-500,500)
	position += get_tree().get_first_node_in_group("Player").position
	visible = true
	$CollisionShape2D.disabled = false

func _deactivate():
	visible = false
	on_screen = false
	velocity = Vector2.ZERO
	$CollisionShape2D.disabled = true

func _physics_process(delta: float) -> void:
	translate(velocity * delta)
	if on_screen:
		velocity.y += custom_gravity * delta * 100

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(10)
	call_deferred("_deactivate")

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true
