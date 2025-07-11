class_name PlayerWindows extends HBoxContainer

var active_index: int = -1

@onready var party: Array = Data.party

func _ready() -> void:
	for i in range(get_child_count()):
		if i < party.size():
			var child = get_child(i)
			child.data = party[i]
			party[i].hp_changed.connect(_on_player_hp_changed.bind(i, child)) # conecta hp_changed
			print("player found")
		else:
			get_child(i).data = null

func activate(player_index: int) -> void:
	# desativa anterior
	if active_index != -1 and active_index < get_child_count():
		get_child(active_index).activate(false)

	active_index = player_index

	# ativa novo, se existir e estiver vivo
	if active_index != -1 and active_index < get_child_count():
		var child = get_child(active_index)
		if child.visible:
			child.activate(true)
			child.update_hp_display()  # <-- força atualizar o texto de HP da janela ativa

func _on_player_hp_changed(hp: int, hp_max: int, value_change: int, index: int, window: Control) -> void:
	if hp <= 0:
		window.hide()

func update_all_hp() -> void:
	for i in range(get_child_count()):
		var child = get_child(i)
		if child.visible:
			child.update_hp_display()
