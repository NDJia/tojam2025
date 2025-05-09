extends CharacterBody2D
var front = preload("res://Temp/CatFront.png")
var back = preload("res://Temp/CatBack.png")
var side = preload("res://Temp/CatSide.png")

## How Many Pixels Per Second The Player Can Move
@export var movement_speed = 100

func _physics_process(delta: float) -> void:
	# Sets the velocity based on the "WASD" inputs from the player.
	velocity = Vector2(Input.get_axis("Left","Right"),Input.get_axis("Up","Down")).normalized() * movement_speed
	move_and_slide()
	
	# Sets the texture of the player depending on the movement direction
	if sign(velocity.x) == 1:
		$Sprite2D.texture = side
		$Sprite2D.flip_h = true
	elif sign(velocity.x) == -1:
		$Sprite2D.texture = side
		$Sprite2D.flip_h = false
	
	if sign(velocity.y) == 1:
		$Sprite2D.texture = front
	elif sign(velocity.y) == -1:
		$Sprite2D.texture = back
