class_name CPU
extends Node3D

@onready var cube: Cube = $Cube

func _enter_tree() -> void:
	GameManager.cpu = self

func _physics_process(delta: float) -> void:
	if GameManager.started_race && !GameManager.finished_race:
		cube.roll(Vector3.FORWARD)
