# Globals.gd
extends Node

var log_func = null

func log_message(message: String) -> void:
	if log_func != null:
		log_func.call(message)
