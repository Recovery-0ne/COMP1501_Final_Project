extends Entity
class_name Player

var direction:= 1

@export var checkpoint_position: Vector2

var wall_check

func _init() -> void:
	self.add_to_group("Player")

func _ready():
	global_position = checkpoint_position
	wall_check = $WallCheck
	for state in $StateMachine.get_children():
		state._initialize($StateMachine, self, sprite, anim, state.name.to_lower())
		states[state.name.to_lower()] = state
	$StateMachine._initialize()
	update_health_display()
		
func move(multiplier:=1.0):
	velocity.x = direction * speed * multiplier
	move_and_slide()

func damage_target():
	if attack_check.is_colliding():
		#Damage all colliding objects
		for i in attack_check.get_collision_count():
			attack_check.get_collider(i).take_damage(damage)
			
func take_damage(_damage:int, _flinch:=true, _apply_frozen_multiplier:=true):
	super(_damage, _flinch, _apply_frozen_multiplier)
	if _flinch and $StateMachine.current_state == states["idle"]:
		$StateMachine.change_state("damaged")
    
func respawn_player():
	dead = false
	global_position = checkpoint_position
	$StateMachine.initialize()
	health = max_health
	$HealthLabel.visible = true
	
func cast_projectile_spell(_spell, _timer):
	if not _spell.visible and _timer.is_stopped():
		_timer.start()
		_spell._activate(self, get_global_mouse_position())
