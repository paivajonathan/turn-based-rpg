extends TextureRect

@onready var animation_menu : AnimationPlayer = $AnimationMenu

func _ready() -> void:
	start_loop()

func start_loop() -> void:
	animation_menu.play("loop")

func _on_button_jogar_pressed() -> void:
	TransitionHandler.fade_out(get_tree().current_scene, "res://gamemap.tscn", .8, Color.ORANGE)

func _on_button_sobre_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_about.tscn")

func _on_button_sair_pressed() -> void:
	get_tree().quit()
