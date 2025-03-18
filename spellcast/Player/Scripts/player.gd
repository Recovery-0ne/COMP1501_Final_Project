extends Entity
class_name Player

var direction:= 1

func _init() -> void:
	self.add_to_group("Player")

func _ready():
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
			
func take_damage(_damage:int, _flinch:=true):
	super(_damage, _flinch)
	if health == 0:
		dead = true
		$StateMachine.change_state("dead")
		$HealthLabel.visible = false
	elif _flinch == true:
		$StateMachine.change_state("damaged")
