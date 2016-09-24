
extends KinematicBody2D

const GRAV = 500
const WALK_SPEED = 60
const JUMP_SPEED = 240
const DUB_JUMP_SPEED = 200
var velocity = Vector2()
var jumping = false
var dub_jumping = false
var air_time = 100
var feet
var anim
var prev_anim
var dub_jump_rdy

func _ready():
	anim = get_node("Sprite/anim")
	feet = get_node("feet")
	feet.add_exception(self)
	set_fixed_process(true)
	set_process_input(true)
	
# Jumping is handled in _input() due to _fixed_process()'s inability to detect button
# releases.
func _input(event):
	#If not jumping allow for a jump.
	if (event.is_action_pressed("ui_up") and !jumping and !dub_jumping):
		velocity.y = -JUMP_SPEED
		set_animation("jump")
		jumping = true
		print("jumping = true")
		
	#If double jump is primed, call for a double jump.
	if (event.is_action_pressed("ui_up") and jumping):
		velocity.y = -DUB_JUMP_SPEED
		dub_jumping = true
		# Setting to idle allows "jump" to play again.
		set_animation("idle")
		set_animation("jump")
		#Turns off dub_jump_rdy so it can be primed again next time.
		dub_jump_rdy = false
		jumping = false
		

func _fixed_process(delta):
	velocity.y += delta * GRAV
		
	if (Input.is_action_pressed("ui_left")):
		velocity.x = -WALK_SPEED
		if  !jumping and !dub_jumping:
			set_animation("walk_left")
	elif (Input.is_action_pressed("ui_right")):
		velocity.x = WALK_SPEED
		if !jumping and !dub_jumping:
			set_animation("walk_right")
	else:
		velocity.x = 0
		set_animation("idle")
		
	var motion = velocity * delta
	move(motion)
	
	if(is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
		
	if feet.is_colliding():
		print("feet colliding!")
		jumping = false
		dub_jumping = false
		dub_jump_rdy = false
		
		
		
func set_animation(animation_name, speed = 1):
	if (anim.get_current_animation() != animation_name):
		anim.play(animation_name, 0.0, speed)
		