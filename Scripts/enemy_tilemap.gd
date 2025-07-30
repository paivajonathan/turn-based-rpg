extends Area2D

@export var lamento_scene: String = "res://Scenes/lamento_drafting.tscn"
@onready var collide_sfx = preload("res://music/sfx/angel-tilemap-collision.mp3")
@onready var player = AudioStreamPlayer.new()

func _ready():
	player.stream = collide_sfx
	add_child(player)
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	print("body_entered chamado com: ", body.name)

	if body.name == "Player":
		print("Colidiu com Player, carregando cena de batalha…")
		player.play()
		TransitionHandler.fade_out(get_tree().current_scene, lamento_scene, 2, Color.BLACK)
