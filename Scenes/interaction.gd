extends Area2D

var can_interact = false:
	set(value):
		can_interact = value
		%Label.visible = value

func _on_body_entered(body: Node2D) -> void:
	can_interact = true


func _on_body_exited(body: Node2D) -> void:
	can_interact = false
