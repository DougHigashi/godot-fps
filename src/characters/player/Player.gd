extends KinematicBody

var hotkeys = {
	KEY_1: 0,
	KEY_2: 1,
	KEY_3: 2,
}

export var mouse_sens = 0.15

onready var camera = $Camera
onready var character_mover = $CharacterMover

onready var  weapon_manager = $Camera/WeaponManager

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	character_mover.init(self)
	
func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
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
	if event is InputEventKey and event.pressed:
		if event.scancode in hotkeys:
			weapon_manager.switch_to_weapon_slot(hotkeys[event.scancode])
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_DOWN:
			weapon_manager.switch_to_next_weapon()
		if event.button_index == BUTTON_WHEEL_UP:
			weapon_manager.switch_to_last_weapon()
		
