
extends RigidBody2D

var player
var feet
var kill_check
var jump_height = 220
var move_speed = 50


func _ready():
	set_process(true)
	feet = get_node("feet")
	feet.add_exception(self) # The Player
	set_mode(2)
	
func _process(delta):
		
#	if feet.is_colliding():
#		kill_check= feet.get_collider()
#		if kill_check.CollisionShape2D.is_trigger():
#			get_tree().reload_current_scene()
			
	if feet.is_colliding():
		print("colliding!")
		if Input.is_action_pressed("player_jump"):
			print("Jump!")
			set_axis_velocity( Vector2(0, -jump_height) )

	if Input.is_action_pressed("player_right"):
		print("moving right!")
		set_axis_velocity( Vector2(move_speed, 0) )
	if Input.is_action_pressed("player_left"):
		print("moving left")
		set_axis_velocity( Vector2(-move_speed, 0) )

