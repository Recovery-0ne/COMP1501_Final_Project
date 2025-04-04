extends Area2D

var initial_position
var creator : Entity
var creator_position : Vector2
var direction : Vector2
@export var speed = 800
@export var rotation_speed = 10
@export var projectile_range = 400
@export var damage = 10

func _ready() -> void:
	initial_position = position

#_target must be a global position
func _activate(_creator : Node2D, _target_pos : Vector2):
	creator = _creator
	#Save the position of the player at the time the fireball is cast to know how far it can travel
	creator_position = creator.position
	#Reset the position (which is global since it needs to move independently from the node that created it)
	position = creator.position + initial_position * _creator.facing_dir
	#Set the rotation to match the direction it's being thrown in
	rotation_speed = abs(rotation_speed) * _creator.facing_dir
	#Direction is the difference in the current position and the target position. Normalize the vector to make it more useful during calculations
	direction = (_target_pos + Vector2(0,-30) - position).normalized()
	$SpellCollider.disabled = false
	$Marker2D/Sprite2D.visible = true
	
func _process(delta: float) -> void:
	if $Marker2D/Sprite2D.visible: #If it's visible, then it has been activated
		translate(direction * speed * delta)
		$Marker2D/Sprite2D.rotate(rotation_speed * delta)
		#Past a certain range, the fireball will burn up/deactivate
		if (position - creator_position).length() > projectile_range:
			_deactivate()

func _deactivate():
	$SpellCollider.disabled = true
	$Marker2D/Sprite2D.visible = false
	$Explosion.visible = true
	$Explosion.play("explode")
	
func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if creator == null: return
	if body != creator:
		call_deferred("_deactivate") #Only call deactivate once the collider is finished with the collision
		if body is Entity:
			body.take_damage(damage, true, false)

func _on_explosion_animation_finished() -> void:
	$Explosion.visible = false
