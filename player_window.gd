class_name PlayerWindow extends Button

var tween: Tween = null

@onready var start_y: float = position.y
@onready var p_name: Label = $PanelContainer/VBoxContainer/PName
@onready var hp_value: Label = $PanelContainer/VBoxContainer/HBoxContainer/HPValue

var data: BattleActor = null:
	set(value):
		if value:
			if value.is_connected("hp_changed", _on_data_hp_changed):
				value.hp_changed.disconnect(_on_data_hp_changed)
			data = value
			data.hp_changed.connect(_on_data_hp_changed)
			p_name.text = data.name.erase(8, 99)
			hp_value.text = str(data.hp)
			show()
		else:
			hide()

func activate(on: bool) -> void:
	var target_y: float = start_y
	var duration: float = 0.5
	
	if on:
		target_y += -8
		
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "position:y", target_y, duration).set_trans(Tween.TRANS_ELASTIC)

func _on_data_hp_changed(hp: int, hp_max: int, value_change: int) -> void:
	self.hp_value.text = str(hp)
