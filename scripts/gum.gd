class_name Player
extends CharacterBody3D

@onready var pivot = $Pivot
@onready var mesh = $Pivot/MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D


const SLOW_SPEED : float = 0.5
const FAST_SPEED : float = 4.0

const MIN_SHAKE_INTENSITY : int =  1500

var mouse_sensitivity : float = 0.005
var hold_left_mouse_btn : bool = false
var hold_middle_mouse_btn : bool = false

var hold_left_mouse_btn_duration : float = 1.0
var current_hold_left_mouse_btn_duration : float = 0

var in_transformation_modus : bool = false
var floating_amount : float = 1.0
var erasing_modus : bool = false

var mesh_original_scale : Vector3

var cube_size = 1.0
var speed : float = SLOW_SPEED
var rolling = false

func _ready() -> void:
	mesh_original_scale = mesh.scale
	
	GameManager.player = self

func _physics_process(delta):
	if !in_transformation_modus && not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
	if !in_transformation_modus && hold_left_mouse_btn:
		current_hold_left_mouse_btn_duration += delta
		
		if current_hold_left_mouse_btn_duration >= hold_left_mouse_btn_duration:
			acces_transformation_mode()
	
	var forward = Vector3.FORWARD
	if Input.is_action_pressed("move foward"):
		roll(forward)
	if Input.is_action_pressed("move back"):
		roll(-forward)
	if Input.is_action_pressed("move right"):
		roll(forward.cross(Vector3.UP))
	if Input.is_action_pressed("move left"):
		roll(-forward.cross(Vector3.UP))

func roll(dir):
	# Do nothing if we're currently rolling.
	if rolling:
		return
	rolling = true

	# Step 1: Offset the pivot.
	pivot.translate(dir * cube_size / 2)
	mesh.global_translate(-dir * cube_size / 2)

	# Step 2: Animate the rotation.
	var axis = dir.cross(Vector3.DOWN)
	var rotation_tween = create_tween()
	rotation_tween.tween_property(pivot, "transform", pivot.transform.rotated_local(axis, PI/2), 1 / speed)
	await rotation_tween.finished
	
	
	# Step 3: Finalize the movement and reset the offset.
	transform.origin += dir * cube_size
	var b = mesh.global_transform.basis
	pivot.transform = Transform3D.IDENTITY
	mesh.position = Vector3(0, cube_size / 2, 0)
	mesh.global_transform.basis = b
	rolling = false

func acces_transformation_mode() -> void:
	in_transformation_modus = true
	current_hold_left_mouse_btn_duration = 0
	
	position.y += floating_amount


func exit_transformation_mode() -> void:
	collision_shape.scale = mesh.scale
	mesh.rotation = collision_shape.rotation
	in_transformation_modus = false

func erasing() -> void:
	erasing_modus = true
	
	if mesh.scale >= mesh_original_scale/2:
		mesh.scale = mesh.scale * 0.999
	else:
		speed = FAST_SPEED

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		hold_left_mouse_btn = true
	if event.is_action_released("action"):
		hold_left_mouse_btn = false

	if in_transformation_modus && event.is_action_pressed("return"):
		exit_transformation_mode()
	
	if in_transformation_modus && hold_left_mouse_btn && event is InputEventMouseMotion:
		var current_shake_intensity = event.velocity.length()
		
		if current_shake_intensity >= MIN_SHAKE_INTENSITY:
			erasing()
		
		mesh.rotation.y += event.relative.x * mouse_sensitivity
		mesh.rotation.x -= event.relative.y * mouse_sensitivity
