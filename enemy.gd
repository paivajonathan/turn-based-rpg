class_name Enemy extends TextureButton

@export var explosion_scene: PackedScene = preload("res://enemy_explosion.tscn")

@export var data: BattleActor = null :
	set(value):
		data = value
		data.hp_changed.connect(_on_data_hp_changed)
		# TODO update sprite
		# etc

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	start_idle()

func _on_focus_entered() -> void:
	print("Highlight")
	animation_player.play("highlight")

func _on_focus_exited() -> void:
	print("Sem highlight")
	animation_player.stop()
	start_idle()
	
func _on_data_hp_changed(hp: int, hp_max: int, value_change: int) -> void:
	if hp <= 0:
		hide()
		
		if explosion_scene: # kaboom!
			var explosion = explosion_scene.instantiate()
			var effects_layer = get_tree().root.get_node("Battle/Effects")
			explosion.global_position = global_position
			effects_layer.add_child(explosion)
	else:
		start_idle()

		
func start_idle() -> void:
	# toca a animação idle em loop
	if not animation_player.is_playing() or animation_player.current_animation != "idle":
		animation_player.play("idle")

func stop_idle() -> void:
	if animation_player.is_playing():
		animation_player.stop()
