extends Camera3D

@export var moveSpeed = 0.5
@export var mouseSpeed = 300.0

var lookAngles = Vector2.ZERO

func _process(_delta):
	# Limit how much we can look up and down.
	lookAngles.y = clamp(lookAngles.y, PI / -2, PI / 2)
	set_rotation(Vector3(lookAngles.y, lookAngles.x, 0))
	# Get the direction to move from the inputs.
	var dir = updateDirection()
	translate(dir * moveSpeed)
	
	# Give the player's mouse back when ESC is pressed.
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	return
func updateDirection():
	# Get the direction to move the camera from the input.
	var dir = Vector3()
	if Input.is_action_pressed("move_forward"):
		dir += Vector3.FORWARD
	if Input.is_action_pressed("move_backward"):
		dir += Vector3.BACK
	if Input.is_action_pressed("move_left"):
		dir += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		dir += Vector3.RIGHT
	return dir.normalized()

func _input(event):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		lookAngles -= event.relative / mouseSpeed
	  
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
