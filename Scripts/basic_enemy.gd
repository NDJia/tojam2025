extends Node2D
var side = preload("res://Assets/Textures/Cows/Water/WaterCowSide.png")
var front = preload("res://Assets/Textures/Cows/Water/WaterCowFront.png")
var back = preload("res://Assets/Textures/Cows/Water/WaterCowBack.png")


@onready var player = get_node("../../Player")
## A Refrence To The Player

var damage = 10
## How much damage is dealt to the player on collision

var knockback = 600
## How much knockback is dealt to the player on collsision

var speed = 50
## Speed Of The Enemy

var condition = "Idle"
## Current Condition Of The Enemy

var range = 150
## Range Where The Enemy Detects The Player

func _ready() -> void:
	speed += randi_range(-20,20)
	$SmokeAnim.play("smoke")

func _physics_process(delta: float) -> void:
	var dir = ($Nav.get_next_path_position() - global_position).normalized()
	global_position += dir * speed * delta
	
	dir = dir.angle()
	if dir <= -3*PI / 4:
		$Body.texture = side
		$Body.flip_h = true
		$SmokeTexture.position.x = -30
		$SmokeTexture.visible = true
	elif dir <= -PI / 4:
		$Body.texture = back
		$Body.flip_h = false
		$SmokeTexture.visible = false
	elif dir <= PI / 4:
		$Body.texture = side
		$Body.flip_h = false
		$SmokeTexture.position.x = 30
		$SmokeTexture.visible = true
	elif dir <= 3*PI / 4:
		$Body.texture = front
		$Body.flip_h = false
		$SmokeTexture.visible = false
	else:
		$Body.texture = side
		$Body.flip_h = true
		$SmokeTexture.position.x = -30
		$SmokeTexture.visible = true

func Update_Target() -> void:
	if global_position.distance_to(player.position) < range:
		condition = "Attack"
	if condition != "Idle":
		$Nav.target_position = player.position
	$UpdateTarget.start()
