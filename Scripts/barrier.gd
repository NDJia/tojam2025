extends Node2D

func Check() -> void:
	var done = true
	for child in get_parent().get_children():
		if child.name.contains("Enemy"):
			done = false
			break
	if done:
		queue_free()
			
