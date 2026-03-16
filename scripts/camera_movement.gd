extends SpringArm3D



@onready var camera_3d: Camera3D = $Camera3D

func _unhandled_input(event: InputEvent) -> void:
	#camera movement
	if event.is_action_pressed("camera move"):
		GameManager.player.hold_middle_mouse_btn = true
	if event.is_action_released("camera move"):
		GameManager.player.hold_middle_mouse_btn = false
	
	if GameManager.player.hold_middle_mouse_btn && event is InputEventMouseMotion:
		rotation.y -= event.relative.x * GameManager.player.mouse_sensitivity
		rotation.x -= event.relative.y * GameManager.player.mouse_sensitivity
