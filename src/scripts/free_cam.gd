extends Camera3D

@export var speed := 6.0
@export var sens := 0.002

var yaw := 0.0
var pitch := 0.0
var base_rotation := Vector3.ZERO

func _ready():
	base_rotation = rotation
	get_window().focus_entered.connect(_on_focus)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_focus():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(e):
	if e is InputEventKey and e.pressed and e.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if e is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		yaw -= e.relative.x * sens
		pitch -= e.relative.y * sens
		pitch = clamp(pitch, deg_to_rad(-89), deg_to_rad(89))

func _process(delta):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return

	var rot := base_rotation
	rot.y += yaw
	rot.x += pitch
	rotation = rot

	var move := Vector3.ZERO

	if Input.is_key_pressed(KEY_W):
		move -= transform.basis.z
	if Input.is_key_pressed(KEY_S):
		move += transform.basis.z
	if Input.is_key_pressed(KEY_A):
		move -= transform.basis.x
	if Input.is_key_pressed(KEY_D):
		move += transform.basis.x

	position += move.normalized() * speed * delta
