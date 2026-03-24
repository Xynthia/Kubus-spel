extends SpringArm3D

@onready var camera_3d: Camera3D = $Camera3D


func _physics_process(delta: float) -> void:
	if GameManager.player.cube.rolling:
		global_position = GameManager.player.cube.next_face.global_position
		global_position.y = 1

func _unhandled_input(event: InputEvent) -> void:
	#camera movement
	if GameManager.player.hold_middle_mouse_btn && !GameManager.player.in_transformation_modus && event is InputEventMouseMotion:
		rotation.y -= event.relative.x * GameManager.player.mouse_sensitivity
		rotation.x -= event.relative.y * GameManager.player.mouse_sensitivity
		
		GameManager.player.sprite_pivot.rotation = rotation
