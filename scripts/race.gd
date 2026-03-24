class_name Race
extends Node3D


func _on_finish_area_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	GameManager.finished_race = true
	GameManager.won_race_name = area.get_owner().get_parent().name
