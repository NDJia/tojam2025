extends Node2D
var time = 0.5
## How long the damage stays active

func _process(delta: float) -> void:
	time -= delta
	if time < 0:
		time = 0
	if $Hitbox.has_overlapping_areas() and time != 0:
		for enemy in $Hitbox.get_overlapping_areas():
			enemy.get_parent().hit(10)
			enemy.get_parent().push(10,global_position)


func Despawn() -> void:
	queue_free()
