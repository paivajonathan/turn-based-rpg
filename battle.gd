extends Control

const Actions: Dictionary = EventQueue.Actions

var action: EventQueue.Actions = -1
var current_player_index: int = -1

@onready var options: Menu = $MarginContainer/Options
@onready var enemies: Menu = $Enemies
@onready var player_windows: PlayerWindows = $MarginContainer/PlayerWindows
@onready var event_queue: EventQueue = $EventQueue
@onready var game_over_label: Label = $GameOverLabel
@onready var log_label: RichTextLabel = $LogPanel/LogText


func _ready() -> void:
	Globals.log_func = func(msg: String):
		log_label.append_text(msg + "\n")
		log_label.scroll_to_line(log_label.get_line_count() - 1)

	Globals.log_message("BATALHA INICIADA")
	Data.setup_enemies()
	Data.setup_party()
	setup_enemy_buttons()
	
	# Rolar a CA antes da batalha
	var rng = RandomNumberGenerator.new()
	var draft_roll = rng.randi_range(1, 20)
	for actor in Data.party:
		actor.ca = draft_roll
	player_windows.update_all()

	
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
	if game_over_label.visible:
		# se o jogo acabou, só aceita Enter ou Es
		if event.is_action_pressed("ui_text_backspace"):
			get_tree().change_scene_to_file("res://gamemap.tscn")
		elif event.is_action_pressed("ui_cancel"):
			get_tree().quit()
		return
	
	# código normal para cancelar turnos
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
	
	if all_players_dead():
		Globals.log_message("Game Over! Você morreu")
		return
	
	if current_player_index >= Data.party.size():
		# Adiciona os NPCs já aqui, antes de rodar os eventos
		for enemy in enemies.get_buttons():
			var actor: BattleActor = enemy.data
			if actor.hp <= 0:
				print(actor.name, " está morto e não pode atacar.")
				continue #npc is dead - next!
			var target: BattleActor = event_queue.pick_random_alive(Data.party)
			if target != null: #npc turn
				event_queue.add(Actions.FIRE, actor, target, true)
		
		#enemies.release()
		player_windows.activate(-1)
		
		options.hide() # Cadê os botões???
		# TODO sort by speed rolls
		await event_queue.run() # roda jogadores + NPCs no mesmo “turno”
		
		if all_players_dead():
			print("Game Over! Você morreu")
			show_game_over("Game Over! Você morreu")
			return
		elif all_enemies_dead():
			print("Fim de Jogo! Você venceu!")
			show_game_over("Fim de Jogo! Você venceu!")
			return
		
		current_player_index = 0
	
	if Data.party[current_player_index].hp <= 0:
		goto_next_player()
		return
		
	action = -1
	print(current_player_index)
	player_windows.activate(current_player_index)
	options.show() # Achoou!!
	options.button_focus()


func _on_options_button_pressed(button: BaseButton, _index: int) -> void:
	match button.text:
		"Fire":
			action = Actions.FIRE
			Globals.log_message("Ação escolhida: Fire")
			enemies.button_focus()
		"Shield":
			action = Actions.SHIELD
			Globals.log_message("Ação escolhida: Shield")
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
	
func show_game_over(message: String) -> void:
	game_over_label.text = message
	game_over_label.show()
	$LogPanel.hide()
	options.hide()
	enemies.hide()
	player_windows.hide()


func _on_button_run_pressed() -> void:
	TransitionHandler.fade_out(get_tree().current_scene, "res://gamemap.tscn", .8, Color.WHITE)
