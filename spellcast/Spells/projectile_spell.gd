extends Area2D

var initial_position
var creator : Node2D
var creator_position : Vector2
var direction : Vector2
@export var speed = 400
@export var projectile_range = 400
@export var damage = 10
@export var effect_function_name : String

func _ready() -> void:
	initial_position = position

#_target must be a global position
func _activate(_creator : Node2D, _target : Vector2):
	creator = _creator
	#Save the position of the player at the time the fireball is cast to know how far it can travel
	creator_position = creator.position
	#Reset the position (which is global since it needs to move independently from the node that created it)
	position = creator.position + initial_position
	#Direction is the difference in the current position and the target position. Normalize the vector to make it more useful during calculations
	direction = (_target - position).normalized()
	#Turn the sprite to face the direction it will move in. Use look_at() and pass a point in the path the object will take
	$Marker2D.look_at(position + direction)
	$SpellCollider.disabled = false
	visible = true
	
func _process(delta: float) -> void:
	if visible: #If it's visible, then it has been activated
		translate(direction * speed * delta)
		#Past a certain range, the fireball will burn up/deactivate
		if (position - creator_position).length() > projectile_range:
			_deactivate()

func _deactivate():
	$SpellCollider.disabled = true
	visible = false
	
func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if creator == null: return
	if body != creator:
		call_deferred("_deactivate") #Only call deactivate once the collider is finished with the collision
		if body is Player or body is Enemy:
			body.take_damage(damage, false)
			body.apply_effect(effect_function_name)
			
