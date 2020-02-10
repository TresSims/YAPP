extends RigidBody

const ACCEL = 1.5
const MAX_SPEED = 15
const JERK = 10
const JUMP_SPEED = 13
const THRESHOLD = .35
const DECAY = 0.7
const GRAVITY = .3
const SLIP = .5
const MAX_HOLD_TIME = 1.5

var HOLD_TIME = MAX_HOLD_TIME
var vel = Vector3(0,0,0)
var state = "FREE"
var state_changed = false

onready var DownRay = get_node("DownRay")
onready var collider = get_node("CollisionShape")

func _physics_process(delta):
	process_input(delta)
	process_collisions(delta)

func _integrate_forces(delta):
	process_movement(delta)
	process_decay(delta)
	state_changed = false
	print(state)
	print(linear_velocity)

func process_collisions(delta):
	print(collider.get_collider_position())

func process_input(delta):
	# Check for new wall collisions
	if false and state != "WALL":
		state = "WALL"
		state_changed = true
		linear_velocity = Vector3(0, 0, 0)
	if false and state != "WALL":
		state = "WALL"
		state_changed = true
		linear_velocity = Vector3(0, 0, 0)
	
	if state == "WALL":
		HOLD_TIME -= delta
		if HOLD_TIME <= 0:
			print("slip")
			vel.y -= GRAVITY * SLIP
		
		if Input.is_action_pressed("ui_right") and false:
			vel.x += ACCEL * JERK
			vel.y += JUMP_SPEED
			linear_velocity.y = 0
			state = "FREE"
		
		if Input.is_action_pressed("ui_left") and false:
			vel.x -= ACCEL * JERK
			vel.y += JUMP_SPEED
			linear_velocity.y = 0
			state = "FREE"
		
		print(HOLD_TIME)
	
	# Basic Ground and Air Movement
	if state == "FREE":
		if Input.is_action_pressed("ui_right"):
			vel.x += ACCEL
		if Input.is_action_just_pressed("ui_right") and linear_velocity.x < 0:
			vel.x *= JERK
			print("Jerk Input")
		
		if Input.is_action_pressed("ui_left"):
			vel.x -= ACCEL
		if Input.is_action_just_pressed("ui_left") and linear_velocity.x > 0:
			vel.x *= JERK
			print("Jerk Input")
	
		if Input.is_action_pressed("ui_up")  and on_ground() and linear_velocity.y <= 0:
			vel.y += JUMP_SPEED
			print("Jump")

func process_movement(delta):
	linear_velocity += vel
	if state == "FREE":
		if not Input.is_action_pressed("ui_up"):
			if linear_velocity.y > 0:
				linear_velocity.y  = 0
	
	
func process_decay(delta):
	vel = Vector3(0, 0, 0)
	if state == "FREE":
		if abs(linear_velocity.x) > THRESHOLD:
			if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
				linear_velocity.x *= DECAY
		else:
			linear_velocity.x = 0
		if not on_ground():
			linear_velocity.y -= GRAVITY
			
		if(linear_velocity.x > MAX_SPEED):
			linear_velocity.x = MAX_SPEED
		if(linear_velocity.x < -MAX_SPEED):
			linear_velocity.x = -MAX_SPEED

func on_ground():
	return DownRay.is_colliding()
