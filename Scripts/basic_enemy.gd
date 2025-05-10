extends Node2D
var side = preload("res://Assets/Textures/Cows/Water/WaterCowSide.png")
var front = preload("res://Assets/Textures/Cows/Water/WaterCowFront.png")
var back = preload("res://Assets/Textures/Cows/Water/WaterCowBack.png")


@onready var player = get_node("../../Player")
## A Refrence To The Player

var damage = 20
## How much damage is dealt to the player on collision

var knockback = 600
## How much knockback is dealt to the player on collsision

var speed = 40
## Speed Of The Enemy

var condition = "Idle"
## Current Condition Of The Enemy

var range = 150
## Range Where The Enemy Detects The Player

var immune = 0.3
## Lenght of immunity frames

var health = 40
## Health of the enemy

func _ready() -> void:
	$ProgressBar.max_value = health
	$ProgressBar.value = health
	speed += randi_range(-10,10)
	$SmokeAnim.play("smoke")

func _physics_process(delta: float) -> void:
	var dir = ($Nav.get_next_path_position() - global_position).normalized()
	global_position += dir * speed * delta
	
	if health <= 0:
		die()
	
	immune -= delta
	if immune < 0:
		immune = 0
	
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
	
func hit(damage:int, reset_immune = true, ignore_immune = false):
	if immune == 0 or ignore_immune:
		health -= damage
		$Body.modulate = Color("ff0000")
		$Sound.play(0.8)
		$ProgressBar.value = health
		if reset_immune:
			immune = 0.3
		await(get_tree().create_timer(0.1,false).timeout)
		if condition != "Dead":
			$Body.modulate = Color("ffffff")

func die():
	# Starts the dying
	condition = "Dead"
	$Body.modulate = Color("ff0000")
	$Hitbox.monitorable = false
	speed = 0
	await(get_tree().create_timer(1,false).timeout)
	queue_free()
