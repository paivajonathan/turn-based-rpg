extends Node

var party: Array = [preload("res://Players/tampopo.tres"), preload("res://Players/george.tres")]

func _ready() -> void:
	for v in party:
		v.init()
	# party.append()
