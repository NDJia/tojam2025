extends Node2D

var speed = 200
## The speed of the seed

var lifetime = 5
## Lifetime of the seed

var damage = 5

var on_fire = false

func _ready() -> void:
	if on_fire:
		$Fire/Anim.play("burn")

func _physics_process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
	position += Vector2(cos(rotation),sin(rotation)) * delta * speed


func Hit(area: Area2D) -> void:
	area.get_parent().hit(damage,false,true)
	
	if on_fire:
		area.get_parent().burn(2)
	queue_free()
