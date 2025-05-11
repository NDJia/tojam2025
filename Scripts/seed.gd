extends Node2D

var speed = 200
## The speed of the seed

var lifetime = 5
## Lifetime of the seed

func _physics_process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
	position += Vector2(cos(rotation),sin(rotation)) * delta * speed

func Hit(area: Area2D) -> void:
	area.get_parent().hit(5,false,true)
	queue_free()
