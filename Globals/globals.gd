# Globals.gd
extends Node

var npc_threshold: int = 0
var log_func = null

func log_message(message: String) -> void:
	if log_func != null:
		log_func.call(message)
