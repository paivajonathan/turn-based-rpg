extends TextureRect

@onready var animation_menu : AnimationPlayer = $AnimationMenu

func _ready() -> void:
	start_loop()

func start_loop() -> void:
	animation_menu.play("loop")
