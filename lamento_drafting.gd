extends CanvasLayer

@onready var label = $Label
@onready var button = $Button
@onready var spr_anjo = $SprLamento

var sorte_gerada = false

func _ready():
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	if not sorte_gerada:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		Globals.npc_threshold = rng.randi_range(1, 20)
		var helel_font = load("res://font/Metropolitan.ttf")
		var helel_theme = load("res://font/hele_theme.tres")
		
		# Atualiza label e botão
		label.add_theme_font_override("font",helel_font)
		label.theme = helel_theme
		label.text = "Sua resistência será: %d" % Globals.npc_threshold
		button.text = "CONTINUAR"
		sorte_gerada = true
		
		spr_anjo.texture = load("res://Art/anjo_sprite/spr_lamento1.png")
	else:
		# Troca para cena da batalha
		TransitionHandler.fade_out(get_tree().current_scene, "res://Scenes/battle.tscn", .8, Color.FIREBRICK)
