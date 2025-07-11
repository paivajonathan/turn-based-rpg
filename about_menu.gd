extends TextureRect

@onready var animation_menu : AnimationPlayer = $AnimationMenu

func _ready() -> void:
	start_loop()

func start_loop() -> void:
	animation_menu.play("loop")

func _on_button_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_helel.tscn")
