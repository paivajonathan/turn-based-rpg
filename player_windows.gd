class_name PlayerWindows extends HBoxContainer

var active_index: int = -1

@onready var party: Array = Data.party

func _ready() -> void:
	for i in range(get_child_count()):
		if i < party.size():
			get_child(i).data = party[i]
			print("player found")
		else:
			get_child(i).data = null

func activate(player_index: int) -> void:
	if active_index == player_index:
		return
	
	if active_index != -1:
		get_child(active_index).activate(false)
	
	active_index = player_index
	
	if active_index != -1:
		get_child(active_index).activate(true)
