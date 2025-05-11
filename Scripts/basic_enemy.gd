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

var on_fire = false
## Indicates if enemy is on fire

@export var type = "Water"
## Sets the type of cow

func _ready() -> void:
	$Body.flip_h = int(randi_range(0,1))
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
	if condition == "Idle":
		$WalkAnim.play(str(type)+"Idle")
	elif dir <= -3*PI / 4:
		$WalkAnim.play(str(type)+"LeftWalk")
		$SmokeTexture.position.x = -30
		$SmokeTexture.visible = true
	elif dir <= -PI / 4:
		$WalkAnim.play(str(type)+"BackWalk")
		$SmokeTexture.visible = false
	elif dir <= PI / 4:
		$WalkAnim.play(str(type)+"RightWalk")
		$SmokeTexture.position.x = 30
		$SmokeTexture.visible = true
	elif dir <= 3*PI / 4:
		$WalkAnim.play(str(type)+"FrontWalk")
		$SmokeTexture.visible = false
	else:
		$WalkAnim.play(str(type)+"LeftWalk")
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

func push(force:int,pos:Vector2):
	global_position += (global_position - pos).normalized() * force

func die():
	# Starts the dying
	condition = "Dead"
	$Body.modulate = Color("ff0000")
	$Hitbox.monitorable = false
	speed = 0
	await(get_tree().create_timer(1,false).timeout)
	queue_free()

func burn(lenght = 5):
	if not on_fire:
		on_fire = true
		$Fire/Anim.play("burn")
		$FireTimer.start()
		$BurnTimer.start(lenght)

func FireTimer() -> void:
	health -= 5
	player.heal(5 * player.def_life)
	$ProgressBar.value = health
	$FireTimer.start()

func Extinguish() -> void:
	$FireTimer.stop()
	$Fire/Anim.play("RESET")
	on_fire = false
