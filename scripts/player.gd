class_name Player
extends Node3D

@onready var progressbar_sprite: Sprite3D = $ProgressbarSprite
@onready var progress_bar: TextureProgressBar = $ProgressbarSprite/SubViewport/ProgressBar


var mouse_sensitivity : float = 0.005
var hold_left_mouse_btn : bool = false
var hold_middle_mouse_btn : bool = false

var hold_left_mouse_btn_duration : float = 1.0
var current_hold_left_mouse_btn_duration : float = 0

var in_transformation_modus : bool = false
var floating_amount : float = 1.0
var erasing_modus : bool = false

func _ready() -> void:
	GameManager.player = self
	
	progress_bar.max_value = hold_left_mouse_btn_duration
	progress_bar.step = hold_left_mouse_btn_duration / 100 

func _physics_process(delta: float) -> void:
	#if !in_transformation_modus && not is_on_floor():
		#velocity += get_gravity() * delta
	
	if !in_transformation_modus && hold_left_mouse_btn:
		progressbar_sprite.visible = true
		current_hold_left_mouse_btn_duration += delta
		progress_bar.value = current_hold_left_mouse_btn_duration
		
		if current_hold_left_mouse_btn_duration >= hold_left_mouse_btn_duration:
			acces_transformation_mode()
			
	else:
		progress_bar.value = 0
		progressbar_sprite.visible = false
	pass

func acces_transformation_mode() -> void:
	in_transformation_modus = true
	current_hold_left_mouse_btn_duration = 0
	
	position.y += floating_amount


func exit_transformation_mode() -> void:

	in_transformation_modus = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		hold_left_mouse_btn = true
	if event.is_action_released("action"):
		hold_left_mouse_btn = false

	if in_transformation_modus && event.is_action_pressed("return"):
		exit_transformation_mode()
	
	if in_transformation_modus && hold_left_mouse_btn && event is InputEventMouseMotion:
		var current_shake_intensity = event.velocity.length()
