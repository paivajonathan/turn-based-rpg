extends Area2D

@onready var animation_player: AnimationPlayer = $SprNpc/AnimationIdle

func _ready() -> void:
	start_idle()

func start_idle() -> void:
	animation_player.play("idle")

func _on_body_entered(body: Node) -> void:
	print("body_entered chamado com: ", body.name)
	
	if body.name == "Player":
		print("Colidiu com Player, carregando diálogo...")
