extends CharacterBody2D

var cow = preload("res://Scenes/basic_enemy.tscn")

@onready var player = get_node("../Player")
## A Refrence To The Player

var damage = 20
## How much damage is dealt to the player on collision

var knockback = 1000
## How much knockback is dealt to the player on collsision

var speed = 50
## Speed Of The Enemy

var immune = 0.3
## Lenght of immunity frames

var health = 300
## Health of the enemy

var on_fire = false
## Indicates if enemy is on fire

var attack = "Follow"

var to_summon = 0

func _ready() -> void:	
	$ProgressBar.max_value = health
	$ProgressBar.value = health


func _physics_process(delta: float) -> void:	
	if attack == "Follow":
		$Nav.target_position = player.position
	if attack == "Summon" and to_summon == 0:
		if not $Nav.is_target_reached():
			$Nav.target_position = Vector2.ZERO
		if global_position.x < 5 and global_position.x > -5:
			global_position.x = 0
		if global_position.y < 5 and global_position.y > -5:
			global_position.y = 0
		to_summon = 5
		$SummonTimer.start()
		
	var dir = ($Nav.get_next_path_position() - global_position).normalized()
	velocity = dir * speed

	if health <= 0:
		die()
	immune -= delta
	if immune < 0:
		immune = 0
	dir = dir.angle()
	if dir <= -3*PI / 4:
		$Anim.play("Left")
	elif dir <= -PI / 4:
		$Anim.play("Back")
	elif dir <= PI / 4:
		$Anim.play("Right")
	elif dir <= 3*PI / 4:
		$Anim.play("Front")
	else:
		$Anim.play("Left")
	if $Nav.is_target_reached():
		$Anim.play("Idle")
	move_and_slide()

	
func hit(damage:int, reset_immune = true, ignore_immune = false):
	if immune == 0 or ignore_immune:
		health -= damage
		$Body.modulate = Color("ff0000")
		$Sound.play(0.8)
		$ProgressBar.value = health
		if reset_immune:
			immune = 0.3
		await(get_tree().create_timer(0.1,false).timeout)
		$Body.modulate = Color("ffffff")

func push(force:int,pos:Vector2):
	global_position += (global_position - pos).normalized() * force

func die():
	# Starts the dying
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


func summon() -> void:
	var new_cow = cow.instantiate()
	new_cow.position = global_position
	var rand = randi_range(1,3)
	if rand == 1:
		new_cow.type = "Water"
	elif rand == 2:
		new_cow.type = "Fire"
	else:
		new_cow.type = "Choco"
	get_parent().add_child(new_cow)
	to_summon -= 1
	if to_summon <= 0:
		$SummonTimer.start


func ChangeAttack() -> void:
	if attack == "Follow":
		attack = "Summon"
	elif attack == "Summon":
		attack = "Follow"
