class_name Cube
extends Node3D

const SLOW_SPEED : float = 1.0
const FAST_SPEED : float = 4.0

enum DIR {foward, backward, left, right}
enum FACES {top, right, bottem, left, foward, back}

@onready var check_faces: RayCast3D = $CheckFaces


@onready var pivot: Node3D = $Pivot
@onready var mesh: MeshInstance3D = $Pivot/MeshInstance3D

@onready var face_1: Area3D = $Pivot/MeshInstance3D/faces/face1
@onready var face_2: Area3D = $Pivot/MeshInstance3D/faces/face2
@onready var face_3: Area3D = $Pivot/MeshInstance3D/faces/face3
@onready var face_4: Area3D = $Pivot/MeshInstance3D/faces/face4
@onready var face_5: Area3D = $Pivot/MeshInstance3D/faces/face5
@onready var face_6: Area3D = $Pivot/MeshInstance3D/faces/face6

@onready var _1: RayCast3D = $"Pivot/MeshInstance3D/faces/1"
@onready var _2: RayCast3D = $"Pivot/MeshInstance3D/faces/2"
@onready var _3: RayCast3D = $"Pivot/MeshInstance3D/faces/3"
@onready var _4: RayCast3D = $"Pivot/MeshInstance3D/faces/4"
@onready var _5: RayCast3D = $"Pivot/MeshInstance3D/faces/5"
@onready var _6: RayCast3D = $"Pivot/MeshInstance3D/faces/6"

@onready var a: RayCast3D = $Pivot/MeshInstance3D/Vertices/A
@onready var b: RayCast3D = $Pivot/MeshInstance3D/Vertices/B
@onready var c: RayCast3D = $Pivot/MeshInstance3D/Vertices/C
@onready var d: RayCast3D = $Pivot/MeshInstance3D/Vertices/D
@onready var e: RayCast3D = $Pivot/MeshInstance3D/Vertices/E
@onready var f: RayCast3D = $Pivot/MeshInstance3D/Vertices/F
@onready var g: RayCast3D = $Pivot/MeshInstance3D/Vertices/G
@onready var h: RayCast3D = $Pivot/MeshInstance3D/Vertices/H

@onready var ab: Node3D = $Pivot/MeshInstance3D/Sides/AB
@onready var bc: Node3D = $Pivot/MeshInstance3D/Sides/BC
@onready var cd: Node3D = $Pivot/MeshInstance3D/Sides/CD
@onready var da: Node3D = $Pivot/MeshInstance3D/Sides/DA
@onready var ae: Node3D = $Pivot/MeshInstance3D/Sides/AE
@onready var bf: Node3D = $Pivot/MeshInstance3D/Sides/BF
@onready var cg: Node3D = $Pivot/MeshInstance3D/Sides/CG
@onready var dh: Node3D = $Pivot/MeshInstance3D/Sides/DH
@onready var ef: Node3D = $Pivot/MeshInstance3D/Sides/EF
@onready var fg: Node3D = $Pivot/MeshInstance3D/Sides/FG
@onready var gh: Node3D = $Pivot/MeshInstance3D/Sides/GH
@onready var he: Node3D = $Pivot/MeshInstance3D/Sides/HE


@onready var current_face : RayCast3D = _3
var next_face : Area3D 

var cube_size = 1.0
var rolling = false
var speed : float = SLOW_SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("move foward"):
		calculate_next_face(DIR.foward)
		roll(Vector3.FORWARD)
	if Input.is_action_pressed("move back"):
		calculate_next_face(DIR.backward)
		roll(Vector3.BACK)
	if Input.is_action_pressed("move right"):
		calculate_next_face(DIR.right)
		roll(Vector3.LEFT)
	if Input.is_action_pressed("move left"):
		calculate_next_face(DIR.left)
		roll(-Vector3.RIGHT)
		

func roll(dir):
	# Do nothing if we're currently rolling.
	if rolling:
		return
	rolling = true
	
	var tween := Tween.new()
	var y_offset 
	if dir.x != 0:
		y_offset = sqrt(2)/2*cube_size*sin((dir.x * 90)+PI/4)
	elif dir.z !=0:
		y_offset = sqrt(2)/2*cube_size*sin((dir.z * 90)+PI/4)
		
	dir.y = y_offset
	
	#tween.tween_property(mesh, "rotation_degrees", dir * 90, 1)
	tween.tween_property(self, "position", position + dir, 1)

	
	await tween.finished
	
	
	rolling = false

func calculate_next_face(dir : DIR) -> void:
	if rolling:
		return
	
	var distance := 0.6
	
	match dir:
		DIR.foward:
			check_faces.target_position = Vector3.FORWARD * distance
		DIR.backward:
			check_faces.target_position = Vector3.BACK * distance
		DIR.left:
			check_faces.target_position = Vector3.LEFT * distance
		DIR.right:
			check_faces.target_position = Vector3.RIGHT * distance
	

	
	if check_faces.is_colliding():
		next_face = check_faces.get_collider()
	

	var next_side = get_side_beteen_current_next()
	print(next_face, " curr", current_face, " ", next_side)
	if next_side:
		check_if_bevel(next_side)
		current_face = check_face_on()
	

func check_if_bevel(side : Node3D) -> float:
	if side.visible:
		return FAST_SPEED
	else:
		return SLOW_SPEED

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
	match next_face:
		face_1:
			current_face = _1
		face_2:
			current_face = _2
		face_3:
			current_face = _3
		face_4:
			current_face = _4
		face_5:
			current_face = _5
		face_6:
			current_face = _6
	
	return current_face
