extends Camera3D

@export var speed := 6.0
@export var sens := 0.002

var yaw := 0.0
var pitch := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(e):
	if e is InputEventMouseMotion:
		yaw -= e.relative.x * sens
		pitch -= e.relative.y * sens
		pitch = clamp(pitch, deg_to_rad(-89), deg_to_rad(89))
		rotation = Vector3(pitch, yaw, 0)

func _process(delta):
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
