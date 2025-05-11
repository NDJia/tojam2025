extends Node2D

var speed = 100
## The speed of the seed

var lifetime = 10
## Lifetime of the seed

func _physics_process(delta: float) -> void:
	position += Vector2(cos(rotation),sin(rotation)) * delta * speed

func Hit(area: Area2D) -> void:
	area.get_parent().hit(5,false,true)
	queue_free()
