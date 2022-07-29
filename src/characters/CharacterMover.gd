extends Spatial

var body_to_move : KinematicBody = null

export var move_accel = 1
export var max_speed = 5
export var sprint_speed = 2
var drag = 0.0 
export var gravity = 60

var sprinting = false
var move_vec : Vector3
var velocity : Vector3
var snap_vec : Vector3
export var ignore_rotation = false

signal movement_info

var frozen = false

func _ready():
	drag = float(move_accel) / max_speed
	
func init(_body_to_move: KinematicBody):
	body_to_move = _body_to_move

func set_move_vec(_move_vec: Vector3, _sprinting: bool):
	sprinting = _sprinting
	move_vec = _move_vec.normalized()

func _physics_process(delta):
	if frozen:
		return
	var cur_move_vec = move_vec
	
	if !ignore_rotation:
		cur_move_vec = cur_move_vec.rotated(Vector3.UP, body_to_move.rotation.y)

	if sprinting:
		velocity += sprint_speed * cur_move_vec - velocity * Vector3(drag, 0, drag) + gravity * Vector3.DOWN * delta
	else:
		velocity += move_accel * cur_move_vec - velocity * Vector3(drag, 0, drag) + gravity * Vector3.DOWN * delta
	velocity = body_to_move.move_and_slide_with_snap(velocity, snap_vec, Vector3.UP)

	sprinting = false
	emit_signal("movement_info", velocity)

func freeze():
	frozen = true

func unfreeze():
	frozen = false
