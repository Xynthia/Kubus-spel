extends CharacterBody3D

@onready var pivot = $Pivot
@onready var mesh = $Pivot/MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

@onready var progressbar_sprite: Sprite3D = $ProgressbarSprite
@onready var progress_bar: TextureProgressBar = $ProgressbarSprite/SubViewport/ProgressBar

@onready var cube: RigidBody3D = $Cube




const SLOW_SPEED : float = 0.5
const FAST_SPEED : float = 4.0

const JUMP_VELOCITY = 4.5

const MIN_SHAKE_INTENSITY : int =  1500



var mesh_original_scale : Vector3

var cube_size = 1.0
var speed : float = SLOW_SPEED
var rolling = false

enum DIR {foward, backward, left, right}

func _physics_process(delta):
	
	if Input.is_action_pressed("move foward"):
		roll(DIR.foward)
	if Input.is_action_pressed("move back"):
		roll(DIR.backward)
	if Input.is_action_pressed("move right"):
		roll(DIR.right)
	if Input.is_action_pressed("move left"):
		roll(DIR.left)

func roll(dir : DIR):
	match dir:
		DIR.foward:
			cube.roll()
			pass
		DIR.backward:
			cube.roll()
			pass
		DIR.left:
			pass
		DIR.right:
			pass
	
	velocity.y = JUMP_VELOCITY
