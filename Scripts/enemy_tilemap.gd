extends Area2D

@export var lamento_scene: String = "res://Scenes/lamento_drafting.tscn"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	print("body_entered chamado com: ", body.name)

	if body.name == "Player":
		print("Colidiu com Player, carregando cena de batalha…")
		TransitionHandler.fade_out(get_tree().current_scene, lamento_scene, .8, Color.BLACK)
