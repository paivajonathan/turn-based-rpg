class_name EventQueue extends Node

enum Actions {
	FIRE,
	SHIELD,
}

var events: Array[Dictionary] = []

func add(action: Actions, actor: BattleActor, target: BattleActor, is_npc: bool = false) -> void:
	events.append({ 
		"action": action,
		"actor": actor, 
		"target": target,
		"is_npc": is_npc
		})
	print("Adding event: ", actor.name, " is ", Actions.keys()[action], " ", target.name, ".")

func pop_back() -> void:
	events.pop_back()

func log(msg: String) -> void:
	print(msg)
	if Globals.log_func:
		Globals.log_func.call(msg)

func run() -> void:
	# Base case
	if events.is_empty():
		for actor in Data.party:
			actor.change_defense(false)
		print(">> Turno encerrado. Defesas resetadas.")
		return
	
	var event: Dictionary = events.pop_front()
	
	var action: Actions = event.action
	var actor: BattleActor = event.actor
	var target: BattleActor = event.target
	var is_npc: bool = event.get("is_npc", false)

	
	#print("Running event: ", actor.name, " is ", Actions.keys()[action], " ", target.name, ".")
	
	print(">> Executando evento: ", actor.name, " vai ", Actions.keys()[action], " em ", target.name)
	
	match action:
		Actions.FIRE:
			if is_npc:
				Globals.log_message("NPC %s está atacando %s" % [actor.name, target.name])
				print("NPC %s está atacando %s" % [actor.name, target.name])
			else:
				Globals.log_message("Jogador %s está atacando %s" % [actor.name, target.name])
				print("Jogador %s está atacando %s" % [actor.name, target.name])
			target.healhurt(-1, is_npc)
			get_parent().enemies.update_buttons()

		Actions.SHIELD:
			actor.change_defense(true)
			Globals.log_message("%s está se defendendo!" % actor.name)
			print("%s está se defendendo!" % actor.name)
			
	await(get_tree().create_timer(0.5).timeout)
	await(run())
	
func pick_random_alive(party) -> BattleActor: #only alive players
	var alive_party: Array = []
	for actor in party:
		if actor.hp > 0:
			alive_party.append(actor)
	if alive_party.is_empty():
		return null # ou trate como quiser
	return alive_party[randi() % alive_party.size()]
