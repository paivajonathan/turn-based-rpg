class_name EventQueue extends Node

enum Actions {
	FIGHT,
	DEFEND,
	ITEM,
}

var events: Array[Dictionary] = []

func add(action: Actions, actor: BattleActor, target: BattleActor) -> void:
	events.append({ "action": action, "actor": actor, "target": target })
	print("Adding event: ", actor.name, " is ", Actions.keys()[action], " ", target.name, ".")

func pop_back() -> void:
	events.pop_back()

func run() -> void:
	# Base case
	if events.is_empty():
		return
	
	var event: Dictionary = events.pop_front()
	
	var action: Actions = event.action
	var actor: BattleActor = event.actor
	var target: BattleActor = event.target
	
	print("Running event: ", actor.name, " is ", Actions.keys()[action], " ", target.name, ".")
	
	match event.action:
		Actions.FIGHT:
			target.healhurt(-1)
		_:
			pass
			
	await(get_tree().create_timer(0.5).timeout)
	await(run())
