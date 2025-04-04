extends EnemyState

@onready var spells:= get_children()

func _enter():
	super()
		
func _update(delta: float):
	super(delta)
	
func _physics_update(delta: float):
	super(delta)
	
func _exit():
	super()
	
func cast_spell():
	var available_spells = []
	for spell in spells:
		if not spell.visible:
			available_spells.append(spell)
	var i = randi_range(0, available_spells.size() - 1)
	available_spells[i]._activate(enemy, enemy.player.position)
	enemy.attack_cooldown_timer.start()
	enemy.sound_manager.play(available_spells[i].name.to_lower())
	
func _animation_end():
	state_machine.change_state("look_around")
