extends RigidBody

const GRAVITY = 2
const MAX_SPEED = 30
const JUMP_SPEED = 30
const ACCEL = 100

const DEACCEL = .2
const MAX_SLOPE_ANGLE = 50

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

func process_movement(delta):
	move_and_slide(vel, Vector3(0, 1, 0)) 
	
func process_decay(delta):
	if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		vel.x *= DEACCEL
	if(abs(vel.x) < .5):
		vel.x = 0
	
	vel.y -= GRAVITY