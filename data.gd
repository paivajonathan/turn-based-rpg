extends Node

var enemies: Array = []
var party: Array = [preload("res://Players/tampopo.tres"), preload("res://Players/george.tres")]

func _ready() -> void:
	for v in party:
		v.init()
	# party.append()
	
func setup_enemies() -> void:
	enemies.clear()
	for i in range(3):
		var base_enemy = preload("res://Enemies/mister_moustache.tres").duplicate(true)
		var enemy = base_enemy.copy()
		enemy.name = "Mister Moustache %d" % (i+1)
		enemy.hp_max = 1
		enemy.hp = 1
		enemy.init()
		enemies.append(enemy)
