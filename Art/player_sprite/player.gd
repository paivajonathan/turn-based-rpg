extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $SprPlayer/AnimationIdle
var last_direction_suffix = "down_right"

func  _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		velocity = direction * 128.0
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	update_animation()



#func _ready() -> void:
	#start_idle()
#
#func start_idle() -> void:
	#animation_player.play("idle")


func update_animation():
	# If not moving, play the idle animation for the last known direction.
	if velocity.length() == 0:
		animation_player.play("idle_" + last_direction_suffix)
		return

	# When moving, update the last direction suffix AND play the walk animation.
	if velocity.x > 0 and velocity.y > 0:
		last_direction_suffix = "down_right"
		animation_player.play("walk_down_right")
	elif velocity.x > 0 and velocity.y < 0:
		last_direction_suffix = "up_right"
		animation_player.play("walk_up_right")
	elif velocity.x < 0 and velocity.y < 0:
		last_direction_suffix = "up_left"
		animation_player.play("walk_up_left")
	elif velocity.x < 0 and velocity.y > 0:
		last_direction_suffix = "down_left"
		animation_player.play("walk_down_left")
	# Fallbacks for cardinal directions
	elif velocity.x > 0:
		last_direction_suffix = "down_right"
		animation_player.play("walk_down_right")
	elif velocity.x < 0:
		last_direction_suffix = "up_left"
		animation_player.play("walk_up_left")
	elif velocity.y > 0:
		last_direction_suffix = "down_left"
		animation_player.play("walk_down_left")
	elif velocity.y < 0:
		last_direction_suffix = "up_right"
		animation_player.play("walk_up_right")
