extends CanvasLayer

@onready var label = $Label
@onready var button = $Button

var sorte_gerada = false

func _ready():
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	if not sorte_gerada:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		Globals.npc_threshold = rng.randi_range(1, 20)

		# Atualiza label e botão
		label.text = "Sua resistência será: %d" % Globals.npc_threshold
		button.text = "CONTINUAR"
		sorte_gerada = true
	else:
		# Troca para cena da batalha
		get_tree().change_scene_to_file("res://Scenes/battle.tscn")
