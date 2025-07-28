extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $SprNpc/AnimationIdle

func _ready() -> void:
	start_idle()

func start_idle() -> void:
	animation_player.play("idle")
