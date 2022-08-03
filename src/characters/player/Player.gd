extends KinematicBody

export var mouse_sens = 0.15

onready var camera = $Camera
onready var character_mover = $CharacterMover
onready var health_manager = $HealthManager

var dead = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	character_mover.init(self)
	health_manager.init()
	health_manager.connect("dead", self, "kill")
	
func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
	if dead:
		return
	
	var move_vec = Vector3()
	var sprinting = false
	if Input.is_action_pressed("move_forwards"):
		move_vec += Vector3.FORWARD
	if Input.is_action_pressed("move_backwards"):
		move_vec += Vector3.BACK
	if Input.is_action_pressed("move_left"):
		move_vec += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		move_vec += Vector3.RIGHT
	if Input.is_action_pressed("sprint"):
		sprinting = true
	character_mover.set_move_vec(move_vec, sprinting)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x
		camera.rotation_degrees.x -= mouse_sens * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
		
func hurt(damage, dir):
	health_manager.hurt(damage, dir)

func heal(amount):
	health_manager.heal(amount)
	
func kill():
	dead = true
	character_mover.freeze()
