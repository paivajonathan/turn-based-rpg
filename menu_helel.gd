extends TextureRect

@onready var animation_menu : AnimationPlayer = $AnimationMenu
@onready var sfx_click: AudioStreamPlayer = $"../../sfx_click"
@onready var sfx_hover: AudioStreamPlayer = $"../../sfx_hover"

func _ready() -> void:
	start_loop()

func start_loop() -> void:
	animation_menu.play("loop")

func _on_button_jogar_pressed() -> void:
	sfx_click.play(0.05)
	TransitionHandler.fade_out(get_tree().current_scene, "res://gamemap.tscn", .8, Color.ORANGE)

func _on_button_sobre_pressed() -> void:
	sfx_click.play(0.05)
	await sfx_click.finished
	get_tree().change_scene_to_file("res://menu_about.tscn")

func _on_button_sair_pressed() -> void:
	sfx_click.play(0.05)
	await sfx_click.finished
	get_tree().quit()

func _on_button_jogar_mouse_entered() -> void:
	sfx_hover.play(0.11)

func _on_button_sobre_mouse_entered() -> void:
	sfx_hover.play(0.11)

func _on_button_sair_mouse_entered() -> void:
	sfx_hover.play(0.11)
