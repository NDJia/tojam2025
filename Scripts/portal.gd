extends Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Player":
		get_tree().change_scene_to_file("res://Scenes/Islands/Hell.tscn")
