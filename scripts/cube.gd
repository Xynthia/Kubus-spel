class_name Cube
extends Node3D

const SLOW_DURATION : float = 2.0
const FAST_DURATION : float = 1.0

enum DIR {foward, backward, left, right}
enum FACES {top, right, bottem, left, foward, back}

@onready var check_faces: RayCast3D = $CheckFaces

@onready var pivot: Node3D = $Pivot
@onready var mesh: MeshInstance3D = $Pivot/MeshInstance3D
@onready var faces: Node3D = $Pivot/faces
@onready var vertices: Node3D = $Pivot/Vertices
@onready var sides: Node3D = $Pivot/Sides



@onready var face_1: Area3D = $Pivot/faces/face1
@onready var face_2: Area3D = $Pivot/faces/face2
@onready var face_3: Area3D = $Pivot/faces/face3
@onready var face_4: Area3D = $Pivot/faces/face4
@onready var face_5: Area3D = $Pivot/faces/face5
@onready var face_6: Area3D = $Pivot/faces/face6


@onready var _1: RayCast3D = $"Pivot/faces/1"
@onready var _2: RayCast3D = $"Pivot/faces/2"
@onready var _3: RayCast3D = $"Pivot/faces/3"
@onready var _4: RayCast3D = $"Pivot/faces/4"
@onready var _5: RayCast3D = $"Pivot/faces/5"
@onready var _6: RayCast3D = $"Pivot/faces/6"

@onready var a: RayCast3D = $Pivot/MeshInstance3D/Vertices/A
@onready var b: RayCast3D = $Pivot/MeshInstance3D/Vertices/B
@onready var c: RayCast3D = $Pivot/MeshInstance3D/Vertices/C
@onready var d: RayCast3D = $Pivot/MeshInstance3D/Vertices/D
@onready var e: RayCast3D = $Pivot/MeshInstance3D/Vertices/E
@onready var f: RayCast3D = $Pivot/MeshInstance3D/Vertices/F
@onready var g: RayCast3D = $Pivot/MeshInstance3D/Vertices/G
@onready var h: RayCast3D = $Pivot/MeshInstance3D/Vertices/H

@onready var ab: Node3D = $Pivot/Sides/AB
@onready var bc: Node3D = $Pivot/Sides/BC
@onready var cd: Node3D = $Pivot/Sides/CD
@onready var da: Node3D = $Pivot/Sides/DA
@onready var ae: Node3D = $Pivot/Sides/AE
@onready var bf: Node3D = $Pivot/Sides/BF
@onready var cg: Node3D = $Pivot/Sides/CG
@onready var dh: Node3D = $Pivot/Sides/DH
@onready var ef: Node3D = $Pivot/Sides/EF
@onready var fg: Node3D = $Pivot/Sides/FG
@onready var gh: Node3D = $Pivot/Sides/GH
@onready var he: Node3D = $Pivot/Sides/HE

@onready var current_face : RayCast3D = _3
var next_face : Area3D 

@onready var pivot_origin_pos : Vector3 = pivot.position
@onready var pivot_rotation : Vector3 = pivot.rotation
var cube_size = 1.0
var rolling = false
var duration : float = SLOW_DURATION

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("move foward"):
		if calculate_next_face(DIR.foward):
			roll(Vector3.FORWARD)
	if Input.is_action_pressed("move back"):
		if calculate_next_face(DIR.backward):
			roll(Vector3.BACK)
	if Input.is_action_pressed("move right"):
		if calculate_next_face(DIR.right):
			roll(Vector3.RIGHT)
	if Input.is_action_pressed("move left"):
		if calculate_next_face(DIR.left):
			roll(Vector3.LEFT)
		

func roll(dir : Vector3):
	# Do nothing if we're currently rolling.
	if rolling:
		return
	rolling = true
	
	var tween : Tween = get_tree().create_tween()
	
	pivot.translate(dir * cube_size / 2)
	mesh.global_translate(-dir * cube_size / 2)
	faces.global_translate(-dir * cube_size / 2)
	vertices.global_translate(-dir * cube_size / 2)
	sides.global_translate(-dir * cube_size / 2)
	
	var rotation_end = (dir.cross(Vector3.DOWN) * 90) 
	
	tween.tween_property(pivot, "rotation_degrees", rotation_end, duration)
	await tween.finished

	transform.origin += dir * cube_size
	var b = mesh.global_transform.basis
	pivot.transform = Transform3D.IDENTITY
	mesh.position = Vector3(0, cube_size / 2, 0)
	faces.position = Vector3(0, cube_size / 2, 0)
	vertices.position = Vector3(0, cube_size / 2, 0)
	sides.position = Vector3(0, cube_size / 2, 0)
	mesh.global_transform.basis = b
	faces.global_transform.basis = b
	vertices.global_transform.basis = b
	sides.global_transform.basis = b
	
	rolling = false


func calculate_next_face(dir : DIR) -> bool:
	if rolling:
		return false
	
	var distance := 0.6
	check_faces.enabled = true
	
	match dir:
		DIR.foward:
			check_faces.target_position = Vector3.FORWARD 
		DIR.backward:
			check_faces.target_position = Vector3.BACK 
		DIR.left:
			check_faces.target_position = Vector3.LEFT 
		DIR.right:
			check_faces.target_position = Vector3.RIGHT 
	
	if check_faces.is_colliding():
		current_face = check_face_on()
		next_face = check_faces.get_collider()
		check_faces.enabled = false
		
		var next_side = get_side_beteen_current_next()
		if next_side:
			duration = check_if_bevel(next_side)

			print("curr: ", current_face, " next: ", next_face,  " side: ", next_side, " speed: ", duration)
			return true
	return false

func check_if_bevel(side : Node3D) -> float:
	if side.visible:
		return FAST_DURATION
	else:
		return SLOW_DURATION

func get_side_beteen_current_next() -> Node3D:
	match current_face:
		_1:
			match next_face:
				face_2:
					return ab
				face_4:
					return cd
				face_5:
					return da
				face_6:
					return bc
		_2:
			match next_face:
				face_1:
					return ab
				face_3:
					return ef 
				face_5:
					return ae 
				face_6:
					return bf 
		_3:
			match next_face:
				face_2:
					return ef 
				face_4:
					return gh 
				face_5:
					return he 
				face_6:
					return fg 
		_4:
			match next_face:
				face_1:
					return cd 
				face_3:
					return gh 
				face_5:
					return dh 
				face_6:
					return cg   
		_5:
			match next_face:
				face_1:
					return da 
				face_2:
					return ae 
				face_3:
					return he 
				face_4:
					return dh 
		_6:
			match next_face:
				face_1:
					return bc 
				face_2:
					return bf 
				face_3:
					return fg 
				face_4:
					return cg 
					
	return null

func check_face_on() -> RayCast3D:
	if _1.is_colliding():
		current_face = _1
	elif _2.is_colliding():
		current_face = _2
	elif _3.is_colliding():
		current_face = _3
	elif _4.is_colliding():
		current_face = _4
	elif _5.is_colliding():
		current_face = _5
	elif _6.is_colliding():
		current_face = _6

	
	return current_face
