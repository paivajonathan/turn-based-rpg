class_name EventQueue extends Node

enum Actions {
	FIGHT,
	DEFENSE,
	ITEM,
	RUN,
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
		Actions.FIGHT:
			if is_npc:
				print("NPC %s está atacando %s" % [actor.name, target.name])
			else:
				print("Jogador %s está atacando %s" % [actor.name, target.name])
			target.healhurt(-1, is_npc)

		Actions.DEFENSE:
			actor.change_defense(true)
			print("%s está se defendendo!" % actor.name)
			
	await(get_tree().create_timer(0.5).timeout)
	await(run())
