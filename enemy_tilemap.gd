extends Area2D

@export var battle_scene: String = "res://battle.tscn"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	print("body_entered chamado com: ", body.name)

	if body.name == "Player":
		print("Colidiu com Player, carregando cena de batalha…")
		get_tree().change_scene_to_file(battle_scene)
