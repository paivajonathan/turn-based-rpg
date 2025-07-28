extends Node2D

var dialogue : Dialogue:
	set(value):
		dialogue = value
 
		%Icon.texture = value.texture
		%Name.text = value.name
		%Dialogue.text = value.dialogue

#just testing
func _ready():
	dialogue = load("res://Data/Dialogue/0.tres")
