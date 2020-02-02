extends RigidBody

const ACCEL = 30
const JUMP_SPEED = 500

const MAX_SPEED = 25

var vel = Vector3(0,0,0);

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	process_decay(delta)

func process_input(delta):
	vel = Vector3(0, 0, 0);
	if Input.is_action_pressed("ui_right"):
		vel.x += 1
	if Input.is_action_pressed("ui_left"):
		vel.x -= 1
	
	if Input.is_action_just_pressed("ui_up"):
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
	print(linear_velocity)

func process_decay(delta):
	vel = Vector3(0, 0, 0)
