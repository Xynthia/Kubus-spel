extends Node

var player : Player
var cpu : CPU

var CPU = preload("uid://dvb1hxl42w67t").instantiate()
var PLAYER = preload("uid://bwjn310u18tya").instantiate()


var WORLD = preload("uid://c6pq4yvcrkqye").instantiate()
var RACE : Race = preload("uid://cl2b2owl20ng5").instantiate()

var current_scene : Node3D
var started_race: bool = false
var finished_race: bool = false

var won_race_name : String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not player:
		player = PLAYER
	if not cpu:
		cpu = CPU
	
	if player:
		start_testing_area()

func start_testing_area() -> void:
	var scene = get_scene()
	if scene:
		current_scene = WORLD
		
		for nodes in scene.get_children():
			if nodes == WORLD:
				WORLD.visible = true
			if nodes == RACE:
				RACE.visible = false
		
		scene.add_child(WORLD)
		scene.add_child(player)
	spawn(WORLD)
	

func start_race_area() -> void:
	var scene = get_scene()
	if scene:
		current_scene = RACE
		player.ui.start_race.visible = true
		
		for nodes in scene.get_children():
			if nodes == RACE:
				RACE.visible = true
			if nodes == WORLD:
				WORLD.visible = false
		
		scene.add_child(RACE)
		scene.add_child(player)
		scene.add_child(cpu)
	spawn(RACE)

func spawn(spawn_scene) -> void:
	for nodes in spawn_scene.get_children():
		if nodes.is_in_group("PlayerSpawn"):
			if player.cube:
				player.cube.reset_bevel()
				player.global_position = nodes.global_position
				player.cube.global_position = player.global_position
				player.spring_arm_3d.global_position = player.global_position
		if nodes.is_in_group("CPUSpawn"):
			cpu.global_position = nodes.global_position
			if cpu.cube:
				cpu.cube.global_position = cpu.global_position

func get_scene() -> Node3D:
	for nodes in get_tree().root.get_children():
		if nodes.is_in_group("Scene"):
			return nodes
	return null
