extends KinematicBody

const GRAVITY = 9.8
var vel = Vector3()
const MAX_SPEED = 100
const JUMP_SPEED = 70
const ACCEL = 100

const DEACCEL = 2
const MAX_SLOPE_ANGLE = 50

var camera
var rotation_helper
func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	process_decay(delta)

func process_input(delta):
	if Input.is_action_pressed("ui_right"):
		vel.x += delta * ACCEL
		if vel.x > MAX_SPEED:
			vel.x = MAX_SPEED
	if Input.is_action_pressed("ui_left"):
		vel.x -= delta * ACCEL
		if vel.x < -MAX_SPEED:
			vel.x = -MAX_SPEED
	
	print(vel.x)
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			vel.y = JUMP_SPEED

func process_movement(delta):
	move_and_slide(vel, Vector3(0, 1, 0)) 
	
func process_decay(delta):
	if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		vel.x -= DEACCEL * delta
	if(vel.x < .5):
		vel.x = 0
	
	vel.y -= GRAVITY