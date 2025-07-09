extends Control

const Actions: Dictionary = EventQueue.Actions

var action: EventQueue.Actions = -1
var current_player_index: int = -1

@onready var options: Menu = $MarginContainer/Options
@onready var enemies: Menu = $Enemies
@onready var player_windows: PlayerWindows = $MarginContainer/PlayerWindows
@onready var event_queue: EventQueue = $EventQueue

func _ready() -> void:
	print("INICIADO")
	Data.setup_enemies()
	setup_enemy_buttons()
	goto_next_player()

func setup_enemy_buttons() -> void:
	var enemy_actors = Data.enemies
	var enemy_buttons = enemies.get_buttons()
	
	for i in range(enemy_buttons.size()):
		if i >= enemy_actors.size():
			enemy_buttons[i].hide() # caso tenha mais botões que inimigos
			continue
		
		var actor: BattleActor = enemy_actors[i]
		var button: Enemy = enemy_buttons[i]
		
		button.data = actor
		button.disabled = false
		button.show()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if current_player_index > 0 and options.menu_is_focused():
			print("CURRENT PLAYER INDEX AND OPTIONS FOCUSED")
			event_queue.pop_back()
			goto_next_player(-1)
		else:
			enemies.close()
			options.button_focus()
		
		get_viewport().set_input_as_handled()

func goto_next_player(dir: int = 1) -> void:
	current_player_index += dir
	
	if current_player_index >= Data.party.size():
		for enemy in enemies.get_buttons():
			var actor: BattleActor = enemy.data
			if actor.hp <= 0:
				print(actor.name, " está morto e não pode atacar.")
				continue #npc is dead - next!
			var target: BattleActor = event_queue.pick_random_alive(Data.party)
			if target != null: #npc turn
				event_queue.add(Actions.FIGHT, actor, target, true)
		
		#options.hide()
		#enemies.release()
		player_windows.activate(-1)
		
		# TODO sort by speed rolls
		await(event_queue.run())
		
		#if all_players_dead():
			#print("Game Over")
			#get_tree().quit()
		#elif all_enemies_dead():
			#print("Fim de Jogo")
			#get_tree().quit()
		current_player_index = 0
		
	if Data.party[current_player_index].hp <= 0:
		goto_next_player()
		return
		
	action = -1
	print(current_player_index)
	player_windows.activate(current_player_index)
	options.button_focus()


func _on_options_button_pressed(button: BaseButton, _index: int) -> void:
	match button.text:
		"Fight":
			action = Actions.FIGHT
			print("Ação escolhida: Fight")
			enemies.button_focus()
		"Defense":
			action = Actions.DEFENSE
			print("Ação escolhida: Defense")
			var actor: BattleActor = Data.party[current_player_index]
			event_queue.add(action, actor, actor)
			goto_next_player()
		_:
			print("Ação desconhecida! Texto do botão: ", button.text)


func _on_enemies_button_pressed(button: BaseButton, index: int) -> void:
	var actor: BattleActor = Data.party[current_player_index]
	var target: BattleActor = button.data
	event_queue.add(action, actor, target)
	print(target.name, " HP: ", target.hp)
	goto_next_player()
	
func all_players_dead() -> bool:
	for player in Data.party:
		if player.hp > 0:
			return false
	return true

func all_enemies_dead() -> bool:
	for enemy_button in enemies.get_buttons():
		var enemy = enemy_button.data
		if enemy.hp > 0:
			return false
	return true
