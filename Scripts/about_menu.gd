extends TextureRect

@onready var animation_menu : AnimationPlayer = $AnimationMenu
@onready var sfx_click: AudioStreamPlayer = $"../../sfx_click"
@onready var sfx_hover: AudioStreamPlayer = $"../../sfx_hover"


func _ready() -> void:
	start_loop()

func start_loop() -> void:
	animation_menu.play("loop")

func _on_button_voltar_pressed() -> void:
	sfx_click.play(0.05)
	await sfx_click.finished
	get_tree().change_scene_to_file("res://Scenes/menu_helel.tscn")

func _on_button_voltar_mouse_entered() -> void:
	sfx_hover.play(0.11)
