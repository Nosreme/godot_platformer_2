
extends KinematicBody2D

const GRAV = 500
const WALK_SPEED = 60
const JUMP_SPEED = 260 #Slightly increased jump speed so you could make the first jump
const DUB_JUMP_SPEED = 200
var velocity = Vector2()
var jumping = false
var dub_jumping = false
var air_time = 100
var feet
var anim
var prev_anim
#var dub_jump_rdy #I commented this var out because it wasn't used and I didn't think you needed it

#jump cooldown
var jump_cooldown = 0.1
var jump_cooldown_timer = -1.0

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
	#Disallow jumping if falling.
	#Note: I kept the previous if statements in case you want to allow the player to jump twice when falling
	#if (event.is_action_pressed("ui_up") and !jumping and !dub_jumping):
	if (event.is_action_pressed("ui_up") and !jumping and !dub_jumping and feet.is_colliding()):
		velocity.y = -JUMP_SPEED
		set_animation("jump")
		jumping = true
		#Start jump cooldown as soon as the jump key is pressed
		jump_cooldown_timer = jump_cooldown
		print("jumping = true")
		
	#If double jump is primed, call for a double jump.
	#Also allow double jump if falling without having jumped.
	#Note: same as previous note
	#Note2: changed "if" to "elif" because the double jump was triggering on the same button press as the normal jump
	#elif (event.is_action_pressed("ui_up") and jumping):
	elif (event.is_action_pressed("ui_up") and (jumping or (not dub_jumping and not feet.is_colliding()))):
		velocity.y = -DUB_JUMP_SPEED
		dub_jumping = true
		# Setting to idle allows "jump" to play again.
		set_animation("idle")
		set_animation("jump")
		#Turns off dub_jump_rdy so it can be primed again next time.
		#dub_jump_rdy = false
		jumping = false
		print("dub_jumping = true")
		

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
	
	#Wait for the cooldown before checking for feet collison
	#This way the character will have time to get off the ground before another collision is detected
	#Previously it was checking for collisions the instant the player pressed jump, so the raycast was still in the same position
	if(jump_cooldown_timer < 0):
		if feet.is_colliding():
			print("feet colliding!")
			jumping = false
			dub_jumping = false
			#dub_jump_rdy = false
	#Decrement the cooldown while it's still to high
	else:
		jump_cooldown_timer -= delta
	
func set_animation(animation_name, speed = 1):
	if (anim.get_current_animation() != animation_name):
		anim.play(animation_name, 0.0, speed)
		