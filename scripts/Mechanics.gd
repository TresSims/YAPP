extends RigidBody

const ACCEL = 60
const MAX_SPEED = 15
const JERK = 3
const JUMP_SPEED = 750
var DECAY = 0.95
var vel = Vector3(0,0,0)
var THRESHOLD = .05

onready var DownRay = get_node("DownRay")

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	process_decay(delta)

func process_input(delta):
	if Input.is_action_pressed("ui_right"):
		vel.x += 1
	if Input.is_action_just_pressed("ui_right") and linear_velocity.x < 0:
		vel.x *= JERK
		print("Jerk Input")
	
	if Input.is_action_pressed("ui_left"):
		vel.x -= 1
	if Input.is_action_just_pressed("ui_left") and linear_velocity.x > 0:
		vel.x *= JERK
		print("Jerk Input")
	
	if Input.is_action_just_pressed("ui_up")  && on_ground():
		vel.y += 1
	
	if not Input.is_action_pressed("ui_up"):
		if linear_velocity.y > 0:
			linear_velocity.y  = 0
	
	if abs(linear_velocity.x) > MAX_SPEED:
		vel.x = 0
	
	vel.x *= ACCEL
	vel.y *= JUMP_SPEED

func process_movement(delta):
	add_central_force(vel)
	if(linear_velocity.x > MAX_SPEED):
		linear_velocity.x = MAX_SPEED
	# print(linear_velocity)

func process_decay(delta):
	vel = Vector3(0, 0, 0)
	if abs(linear_velocity.x) > THRESHOLD:
		if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			linear_velocity.x *= DECAY
	else:
		linear_velocity.x = 0

func on_ground():
	return DownRay.is_colliding()
