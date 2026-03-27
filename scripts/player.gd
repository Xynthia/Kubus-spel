class_name Player
extends Node3D

const FREESOUND_COMMUNITY_PENCIL_ERASER_107852 = preload("uid://dqavn78qvvbmb")
const OUBLE_BLINK_CUTE_HIGH_PLUCKS = preload("uid://ba86g2lkknjv8")
const RISING_BUBBLES_TRANSITION_FAST = preload("uid://d0l3ru4jrhgri")
const LIGHTNINGBULB_SPACEBAR_CLICK_KEYBOARD_199448 = preload("uid://dkimiv2nocm0o")
const CHISEL_SCRAPE_LIGHT_DEBRIS = preload("uid://cuj8y73yjmdik")



@onready var cube: Cube = $Cube
@onready var spring_arm_3d: SpringArm3D = $SpringArm3D

@onready var sprite_pivot: Node3D = $"SpringArm3D/Sprite pivot"
@onready var progressbar_sprite: Sprite3D = $"SpringArm3D/Sprite pivot/ProgressbarSprite"
@onready var progress_bar: TextureProgressBar = $"SpringArm3D/Sprite pivot/ProgressbarSprite/SubViewport/ProgressBar"

@onready var erasing_sfx: AudioStreamPlayer3D = $erasing_sfx
@onready var racing_sfx: AudioStreamPlayer = $racing_sfx
@onready var sfx: AudioStreamPlayer3D = $sfx


@onready var erase_checker: Area3D = $EraseChecker
@onready var eraserbits: GPUParticles3D = $eraserbits
@onready var bottem_side: RayCast3D = $BottemSide



@onready var ui: UI = $UI

var mouse_sensitivity : float = 0.005
var hold_left_mouse_btn : bool = false
var hold_middle_mouse_btn : bool = false

var hold_left_mouse_btn_duration : float = 1.0
var current_hold_left_mouse_btn_duration : float = 0

var in_transformation_modus : bool = false
var rotation_cube_pickup : Vector3
var start_rotation_camera : Vector3
var floating_amount : float = 1.0
var erasing : bool = false

var side : Area3D

func _enter_tree() -> void:
	GameManager.player = self

func _ready() -> void:
	start_rotation_camera = spring_arm_3d.rotation
	
	progress_bar.max_value = hold_left_mouse_btn_duration
	progress_bar.step = hold_left_mouse_btn_duration / 100 

func _physics_process(delta: float) -> void:
	if !cube.rolling && !in_transformation_modus && hold_left_mouse_btn:
		progressbar_sprite.visible = true
		current_hold_left_mouse_btn_duration += delta
		progress_bar.value = current_hold_left_mouse_btn_duration
		
		if current_hold_left_mouse_btn_duration >= hold_left_mouse_btn_duration:
			acces_transformation_mode()
	else:
		progressbar_sprite.visible = false
	
	if erasing:
		erasing_sfx.volume_db = -12
	else:
		erasing_sfx.volume_db -= 1
	

func erase() -> void:
	eraserbits.emitting = true
	if side:
		side.visible = true

func acces_transformation_mode() -> void:
	in_transformation_modus = true
	spring_arm_3d.rotation = start_rotation_camera
	
	erase_checker.global_position = cube.global_position
	erase_checker.global_position.y -= 0.8
	
	rotation_cube_pickup = cube.rotation
	current_hold_left_mouse_btn_duration = 0
	
	position += Vector3.UP

func check_which_face_closer_to_ground() -> Area3D:
	var face : Area3D
	bottem_side.global_position = cube.global_position
	bottem_side.target_position = Vector3.DOWN
	face = bottem_side.get_collider()
	return face

func check_which_face_is_front() -> Area3D:
	var face : Area3D
	bottem_side.global_position = cube.global_position
	bottem_side.target_position = Vector3.FORWARD
	face = bottem_side.get_collider()
	return face

func set_on_right_face() -> void:
	var ground_side = check_which_face_closer_to_ground()
	var foward_side = check_which_face_is_front()
	
	var x = snapped(cube.rotation_degrees.x, 90)
	var y = snapped(cube.rotation_degrees.y, 90)
	var z = snapped(cube.rotation_degrees.z, 90)

	cube.rotation_degrees = Vector3(x, y, z)
	

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func exit_transformation_mode() -> void:
	cube.rotation = rotation_cube_pickup
	position.y -= floating_amount
	in_transformation_modus = false

func _unhandled_input(event: InputEvent) -> void:
	if GameManager.current_scene == GameManager.WORLD || GameManager.current_scene == GameManager.RACE && GameManager.started_race && not GameManager.finished_race:
		if Input.is_action_pressed("move foward"):
			if cube.calculate_next_face(cube.DIR.foward):
				cube.roll(Vector3.FORWARD)
		if Input.is_action_pressed("move back"):
			if cube.calculate_next_face(cube.DIR.backward):
				cube.roll(Vector3.BACK)
		if Input.is_action_pressed("move right"):
			if cube.calculate_next_face(cube.DIR.right):
				cube.roll(Vector3.RIGHT)
		if Input.is_action_pressed("move left"):
			if cube.calculate_next_face(cube.DIR.left):
				cube.roll(Vector3.LEFT)
		
		if event.is_action_pressed("action"):
			hold_left_mouse_btn = true
			if !in_transformation_modus:
				sfx.volume_db = -24
				play_sfx(RISING_BUBBLES_TRANSITION_FAST)

		if event.is_action_released("action"):
			hold_left_mouse_btn = false
			current_hold_left_mouse_btn_duration = 0
			progressbar_sprite.visible = false
			sfx.volume_db = -80
		
		if event.is_action_pressed("camera move"):
			hold_middle_mouse_btn = true
		if event.is_action_released("camera move"):
			hold_middle_mouse_btn = false
		
		if in_transformation_modus && event.is_action_pressed("return"):
			exit_transformation_mode()
		
		if in_transformation_modus && hold_middle_mouse_btn && event is InputEventMouseMotion:
			cube.rotation.x += event.relative.y * mouse_sensitivity
			cube.rotation.z -= event.relative.x * mouse_sensitivity
		
		if in_transformation_modus && hold_left_mouse_btn && event is InputEventMouseMotion:
			var current_shake_intensity = event.velocity.length()
			if current_shake_intensity >= 2000:
				erase()
				erasing = true
				cube.position.x = event.relative.x * mouse_sensitivity 
		else:
			erasing = false


func _on_erase_checker_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	side = area


func play_sfx(sound) -> void:
	sfx.stream = sound
	sfx.play()
