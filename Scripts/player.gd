extends CharacterBody2D
var front = preload("res://Assets/Textures/goat_on_pogo.png")
var back = preload("res://Assets/Textures/goat_on_pogo.png")
var side = preload("res://Assets/Textures/goat_on_pogo.png")

var health = 100.0
## The Health Variable Of The Player

var immune = 1
## when this value is above 0 the player is immune to hits, the value goes down by time

var damage = 5
## How much damage the player deals

var is_attacking = false
## Variable that tracks if player is attacking

var attack_cooldown = 0.2
## Seconds the player has to wait before hitting again

@export var grounded = true
## Determines if the player is in the air or not

var state = "Alive"
## State of the player

var active_items = []
## A List Of Currently Active Items

@export_category("Movement Settings")

@export var max_speed = 80
## How Many Pixels Per Second The Player Can Move

var curr_max
## Current Max Speed of the player after all the buffs/debuffs

@export var acceleration = 20
## How Fast The Player Can Accelarate

@export var dash_power = 100
## The Power of The Dash

@export var dash_cooldown = 1
## The Cooldown of The Dash In Seconds

var cooldown = dash_cooldown
## In-Game Cooldown That Changes

func _ready():
	$RyanProgressBar.max_value = dash_cooldown
	$AnimationPlayer.play("Idle")

func _physics_process(delta: float) -> void:
	# Makes The Cooldown Go Down
	cooldown -= delta
	immune -= delta
	if cooldown < 0:
		cooldown = 0
	if immune < 0:
		immune = 0

	$RyanProgressBar.value = dash_cooldown - cooldown
	$RyanHealthBar.value = health
		
	# Sets the velocity based on the "WASD" inputs from the player.
	if state != "Dead":
		velocity += Vector2(Input.get_axis("Left","Right"),Input.get_axis("Up","Down")).normalized() * acceleration * int(grounded)
	# Limits the max speed of the player to the determined speed
	
	curr_max = max_speed - int(is_attacking)*50
	if velocity.length() > curr_max:
		if grounded:
			velocity -= (velocity - velocity.normalized()*curr_max)/2
		else:
			velocity -= (velocity - velocity.normalized()*curr_max)/100
	
	# If no buttons are held the plater slows down
	if Input.get_axis("Left","Right") == 0 and Input.get_axis("Up","Down") == 0 and grounded:
		velocity -= velocity/10
	
	# Rounds the movement of the player if it is very small
	if abs(velocity.x) < 1:
		velocity.x = 0
	if abs(velocity.y) < 1:
		velocity.y = 0
	
	# Start the jump and resets cooldown if the button is pressed
	if state != "Dead":	
		if Input.is_action_just_pressed("Dash") and cooldown == 0:
			jump()
			cooldown = dash_cooldown
 
	if $Hitbox.has_overlapping_areas() and immune == 0 and grounded:
		var enemy = $Hitbox.get_overlapping_areas()[0].get_parent()
		velocity += position.direction_to(enemy.position) * -enemy.knockback
		health -= enemy.damage
		immune = 0.3
		if state != "Dead":
			hit()
			
	if $Weapon/AttackBox.monitoring:
		for enemy in $Weapon/AttackBox.get_overlapping_areas():
			enemy.get_parent().hit(damage)
			
	move_and_slide()

	if health <= 0 and state != "Dead":
		die()


	# Sets the texture of the player depending on the angle of movement
	var a = velocity.angle()
	if velocity == Vector2.ZERO:
		pass
	elif a <= -3*PI / 4:
		$Hitbox/Body.texture = side
		$Hitbox/Body.flip_h = true
	elif a <= PI / 4:
		$Hitbox/Body.texture = side
		$Hitbox/Body.flip_h = false
	else:
		$Hitbox/Body.texture = side
		$Hitbox/Body.flip_h = true
		
	#Checks if the player is attacking
	if Input.is_action_just_pressed("Attack") and not is_attacking and state != "Dead":
		is_attacking = true
		$AttackAnimator.play("Right")

func hit():
	$Hitbox/Body.modulate = Color("ff0000")
	$Sound.play(0.8)
	await(get_tree().create_timer(0.1,false).timeout)
	if state != "Dead":
		$Hitbox/Body.modulate = Color("ffffff")

func die():
	# Starts the dying
	state = "Dead"
	$Die.play(0.8)
	$Hitbox/Body.modulate = Color("ff0000")
	$AnimationPlayer.stop()
	await($Die.finished)
	get_tree().reload_current_scene()
	
func jump():
	# Starts The Jumping Animation
	$AnimationPlayer.play("Dash")
	velocity += dash_power * Vector2(Input.get_axis("Left","Right"),Input.get_axis("Up","Down")).normalized()
	await($AnimationPlayer.animation_finished)
	$AnimationPlayer.play("Idle")

func AttackFinish(anim_name: StringName) -> void:
	$AttackAnimator.play("RESET")
	await(get_tree().create_timer(attack_cooldown,false).timeout)
	$Weapon.look_at(get_global_mouse_position())
	if not Input.is_action_pressed("Attack") or state == "Dead":
		is_attacking = false
	elif anim_name == "Right" and Input.is_action_pressed("Attack"):
		$AttackAnimator.play("Left")
	elif anim_name == "Left" and Input.is_action_pressed("Attack"):
		$AttackAnimator.play("Right")
