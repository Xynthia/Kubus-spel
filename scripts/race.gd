class_name Race
extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_3d: Label3D = $"race track/finish/Label3D"

var race_timer : float

func _process(delta: float) -> void:
	if GameManager.started_race && not GameManager.finished_race:
		race_timer += delta
		var hours: int = int(race_timer / (60.0 * 60.0))
		var minutes: int = int(race_timer / 60.0) % 60
		var seconds: int = int(race_timer) % 60
		var miliseconds: int = int(race_timer * 1000.0) % 1000
		var string: String = "%02d.%02d.%03d" % [minutes, seconds, miliseconds]
		label_3d.text = string


func _on_finish_area_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	GameManager.finished_race = true
	GameManager.won_race_name = area.get_owner().get_parent().name

func play_intro_animation() -> void:
	animation_player.play("move to player")
