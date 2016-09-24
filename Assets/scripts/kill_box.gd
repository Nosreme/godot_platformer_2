
extends Area2D

# member variables here, example:
var player_body

func _ready():
	set_process(true)
	print(player_body)

func _process(delta):
	player_body = get_node("../Player/")
	
	if overlaps_body(player_body):
		print("Collision!")
		get_tree().reload_current_scene()
		


