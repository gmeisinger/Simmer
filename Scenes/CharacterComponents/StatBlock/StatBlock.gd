extends Control

# This is a bare minimum stat block
# should allow the host to take damage and die

signal zero_health()

# Health
var MAX_HP = 100.0
onready var hp = MAX_HP

func _ready():
	$HealthBar.update_bar(hp)
	pass
	
func damage(amt : float):
	hp -= amt
	if hp <= 0.0:
		emit_signal("zero_health")
		hp = 0.0
	$HealthBar.update_bar(hp)

func heal(amt):
	hp += amt
	if hp > MAX_HP:
		hp = MAX_HP
	$HealthBar.update_bar(hp)

func _on_interactable_update_select(_selected):
	$HealthBar.visible = _selected
