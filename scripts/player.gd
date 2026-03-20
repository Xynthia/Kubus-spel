class_name Player
extends Node3D

@onready var cube: Cube = $Cube
@onready var spring_arm_3d: SpringArm3D = $SpringArm3D


@onready var progressbar_sprite: Sprite3D = $"Sprite pivot/ProgressbarSprite"
@onready var progress_bar: TextureProgressBar = $"Sprite pivot/ProgressbarSprite/SubViewport/ProgressBar"

@onready var erase_checker: RayCast3D = $EraseChecker


var mouse_sensitivity : float = 0.005
var hold_left_mouse_btn : bool = false
var hold_middle_mouse_btn : bool = false

var hold_left_mouse_btn_duration : float = 1.0
var current_hold_left_mouse_btn_duration : float = 0

var in_transformation_modus : bool = false
var rotation_cube_pickup : Vector3
var start_rotation_camera : Vector3
var floating_amount : float = 1.0
var erasing_modus : bool = false


func _ready() -> void:
	GameManager.player = self
	
	start_rotation_camera = spring_arm_3d.rotation
	
	progress_bar.max_value = hold_left_mouse_btn_duration
	progress_bar.step = hold_left_mouse_btn_duration / 100 

func _physics_process(delta: float) -> void:	
	if !in_transformation_modus && hold_left_mouse_btn:
		progressbar_sprite.visible = true
		current_hold_left_mouse_btn_duration += delta
		progress_bar.value = current_hold_left_mouse_btn_duration
		
		if current_hold_left_mouse_btn_duration >= hold_left_mouse_btn_duration:
			acces_transformation_mode()

func erase() -> void:
	var side = erase_checker.get_collider()
	if side:
		side.visible = true
	


func acces_transformation_mode() -> void:
	in_transformation_modus = true
	spring_arm_3d.rotation = start_rotation_camera
	
	erase_checker.global_position = cube.global_position
	
	rotation_cube_pickup = cube.rotation
	current_hold_left_mouse_btn_duration = 0
	
	position.y += floating_amount


func exit_transformation_mode() -> void:
	position.y -= floating_amount
	cube.rotation = rotation_cube_pickup
	in_transformation_modus = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		hold_left_mouse_btn = true
	if event.is_action_released("action"):
		hold_left_mouse_btn = false
		current_hold_left_mouse_btn_duration = 0
		progressbar_sprite.visible = false
	
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
		erase()
		cube.global_position.x = event.relative.x * mouse_sensitivity
