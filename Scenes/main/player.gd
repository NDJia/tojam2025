extends CharacterBody2D
var front = preload("res://Temp/CatFront.png")
var back = preload("res://Temp/CatBack.png")
var side = preload("res://Temp/CatSide.png")

@export var grounded = true
## Determines if the player is in the air or not

@export_category("Movement Settings")

@export var max_speed = 150
## How Many Pixels Per Second The Player Can Move

@export var acceleration = 20
## How Fast The Player Can Accelarate

@export var dash_power = 160
## The Power of The Dash

@export var dash_cooldown = 10
## The Cooldown of The Dash In Seconds

var cooldown = dash_cooldown
## In-Game Cooldown That Changes

func _ready():
	$AnimationPlayer.play("Idle")

func _physics_process(delta: float) -> void:
	# Makes The Cooldown Go Down
	cooldown -= delta
	if cooldown < 0:
		cooldown = 0
	$RyanProgressBar.value = 10 - cooldown
		
	# Sets the velocity based on the "WASD" inputs from the player.
	velocity += Vector2(Input.get_axis("Left","Right"),Input.get_axis("Up","Down")).normalized() * acceleration * int(grounded)
	
	# Limits the max speed of the player to the determined speed
	if velocity.length() > max_speed:
		if grounded:
			velocity -= (velocity - velocity.normalized()*max_speed)/2
		else:
			velocity -= (velocity - velocity.normalized()*max_speed)/100
	
	# If no buttons are held the plater slows down
	if Input.get_axis("Left","Right") == 0 and Input.get_axis("Up","Down") == 0 and grounded:
		velocity -= velocity/10
	
	# Rounds the movement of the player if it is very small
	if abs(velocity.x) < 1:
		velocity.x = 0
	if abs(velocity.y) < 1:
		velocity.y = 0
	
	# Start the jump and resets cooldown if the button is pressed	
	if Input.is_action_just_pressed("Dash") and cooldown == 0:
		jump()
		cooldown = dash_cooldown
		
	move_and_slide()

	# Sets the texture of the player depending on the angle of movement
	var a = velocity.angle()
	if velocity == Vector2.ZERO:
		pass
	elif a <= -3*PI / 4:
		$Body.texture = side
		$Body.flip_h = false
	elif a <= -PI / 4:
		$Body.texture = back
		$Body.flip_h = false
	elif a <= PI / 4:
		$Body.texture = side
		$Body.flip_h = true
	elif a <= 3*PI / 4:
		$Body.texture = front
		$Body.flip_h = false
	else:
		$Body.texture = side
		$Body.flip_h = false
 
func jump():
	# Starts The Jumping Animation
	$AnimationPlayer.play("Dash")
	velocity += dash_power * velocity.normalized()
	await($AnimationPlayer.animation_finished)
	$AnimationPlayer.play("Idle")
