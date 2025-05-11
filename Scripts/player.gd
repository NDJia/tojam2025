extends CharacterBody2D
var front = preload("res://Assets/Textures/goat_on_pogo.png")
var back = preload("res://Assets/Textures/goat_on_pogo.png")
var side = preload("res://Assets/Textures/goat_on_pogo.png")
var slam = preload("res://Scenes/ground_slam.tscn")
var seed = preload("res://Scenes/seed.tscn")

var health = 100.0
## The Health Variable Of The Player

var regen = 0
## How much regen per second

var keep_burning = false
## indicates if player will keep burning

var on_fire = false
## Used to keep track of fire

var immune = 1
## when this value is above 0 the player is immune to hits, the value goes down by time

var damage = 5
## How much damage the player deals

var knockback = 10
## How much knocback the player deals

var is_attacking = false
## Variable that tracks if player is attacking

var attack_cooldown = 0.2
## Seconds the player has to wait before hitting again

@export var grounded = true
## Determines if the player is in the air or not

var state = "Alive"
## State of the player

var active_items = {1:[],2:[],3:[],4:[]}
## A List Of Currently Active Items

var main_item = []

@export_category("Movement Settings")

@export var def_max = 50
## How Many Pixels Per Second The Player Can Move

var curr_max
## Current Max Speed of the player after all the buffs/debuffs

var speed_buff = 0
## How much buff to the max speed is applied

@export var def_acc = 20
## How Fast The Player Can Accelarate

@export var def_dash_power = 50
## The Power of The Dash

@export var def_dash_cooldown = 5.0
## The Cooldown of The Dash In Seconds

var autojump = false
## If true makes the player always jump

var dash_cd_buff = 1.0
## How much the dash cooldown is affected

var deadly_jump = false
## if true jumps deal damage

var jump_slowness = 0
## How long the player stays slow after jumping

var cooldown = def_dash_cooldown
## In-Game Cooldown That Changes

var def_life = 0.1
## Default Amount of life per damage

var shoot_cooldown = 1
## Cooldown time between shots

func _ready():
	$RyanProgressBar.max_value = def_dash_cooldown
	$AnimationPlayer.play("Idle")

func _physics_process(delta: float) -> void:
	# Regen
	heal(regen * delta)
	
	# Makes The Cooldown Go Down
	cooldown -= delta
	immune -= delta
	shoot_cooldown -= delta
	if cooldown < 0:
		cooldown = 0
	if immune < 0:
		immune = 0
	if shoot_cooldown < 0:
		shoot_cooldown = 0
		
	print(main_item)
	if main_item != []:
		if main_item[0] == 8:
			main_item[1] -= delta
			if main_item[1] <= 0:
				main_item = []
				process_buffs()
		
	for item in active_items.values():
		if item != []:
			item[1] -= delta
			if item[1] <= 0:
				active_items[active_items.find_key(item)] = []
				process_buffs()

	$RyanProgressBar.value = (def_dash_cooldown * dash_cd_buff) - cooldown
	$RyanHealthBar.value = health
		
	# Sets the velocity based on the "WASD" inputs from the player.
	if state != "Dead":
		velocity += Vector2(Input.get_axis("Left","Right"),Input.get_axis("Up","Down")).normalized() * def_acc * int(grounded)
	# Limits the max speed of the player to the determined speed
	
	curr_max = def_max - int(is_attacking)*50 + speed_buff
	if velocity.length() > curr_max:
		if grounded:
			velocity -= (velocity - velocity.normalized()*curr_max)/2
		else:
			velocity -= (velocity - velocity.normalized()*curr_max)/100
	
	# If no buttons are held the plater slows down
	if Input.get_axis("Left","Right") == 0 and Input.get_axis("Up","Down") == 0 and grounded:
		velocity -= velocity/10
	
	if Input.is_action_pressed("Shoot"):
		shoot()
	
	# Rounds the movement of the player if it is very small
	if abs(velocity.x) < 1:
		velocity.x = 0
	if abs(velocity.y) < 1:
		velocity.y = 0
	
	# Start the jump and resets cooldown if the button is pressed
	if state != "Dead":	
		if (Input.is_action_just_pressed("Dash") or autojump) and cooldown == 0 and grounded:
			$RyanProgressBar.max_value = def_dash_cooldown * dash_cd_buff
			cooldown = def_dash_cooldown * dash_cd_buff
			jump()
			
	# Handles the hitbox detection for collecting food and getting hit
	for area in $Hitbox.get_overlapping_areas():
		if area.get_collision_layer_value(2):
			if immune == 0 and grounded:
				var enemy = $Hitbox.get_overlapping_areas()[0].get_parent()
				if area.name.contains("Sneeze"):
					velocity += position.direction_to(enemy.position) * -60
					burn(10)
					immune = 0.3
				elif area.name.contains("Puddle"):
					heal(-5)
					immune = 0.6
				else:
					velocity += position.direction_to(enemy.position) * -enemy.knockback
					health -= enemy.damage
					immune = 0.3
				if state != "Dead":
					hit()
		elif area.get_collision_layer_value(4):
			if eat(area.get_parent().type,area.get_parent().duration):
				area.get_parent().eat()
			
	# Checks the weapon hitbox for enemies
	if $Weapon/AttackBox.monitoring:
		for enemy in $Weapon/AttackBox.get_overlapping_areas():
			enemy.get_parent().hit(damage)
			enemy.get_parent().push(knockback,global_position)
			heal(damage * def_life)
			if keep_burning:
				enemy.get_parent().burn(5)
			
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
	velocity += def_dash_power * Vector2(Input.get_axis("Left","Right"),Input.get_axis("Up","Down")).normalized()
	await($AnimationPlayer.animation_finished)
	if deadly_jump:
		var new_slam = slam.instantiate()
		new_slam.position = global_position
		get_parent().add_child(new_slam)
	$AnimationPlayer.play("Idle")

const descriptions = [
	# 0
	"Your dash cooldown is halved, but you always jump as soon as you can.",
	# 1
	"Your attacks burn enemies, but you're also on fire!",
	# 2
	"",
	# 3
	"Landing after a Super Jump deals damage to nearby enemies, but you are slow after landing.",
	# 4
	"You are much faster, but you have been poisoned by chocolate!",
	#5
	"",
	#6
	"",
	#7
	""
]

func eat(type:int,duration:float) -> bool:
	if type < 6:
		var slot = -1
		for x in range(1,5):
			if active_items.get(x) == []:
				slot = x
				break
		if slot == -1:
			return false
		active_items[slot] = [type,duration,descriptions[type-1]]
		if type == 3:
			heal(20)
		process_buffs()
	elif type > 5:
		if main_item != []:
			return false
		else:
			main_item = [type,duration]
			process_buffs()
	return true

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

func process_buffs():
	jump_slowness = 0
	dash_cd_buff = 1.0
	autojump = false
	deadly_jump = false
	speed_buff = 0
	keep_burning = false
	def_life = 0.1
	regen = 0
	$PoisonTimer.stop()
	# Resets the buffs
	if main_item != []:
		if main_item[0] == 8:
			regen += 2
			def_life += 0.2
		
	for item in active_items.values():
		if item.get(0) == 1:
			dash_cd_buff /= 2
			autojump = true
		elif item.get(0) == 2:
			keep_burning = true
			burn(5)
		elif item.get(0) == 3: 
			pass #Has no passive effect
		elif item.get(0) == 4:
			deadly_jump = true
			jump_slowness += 1
		elif item.get(0) == 5:
			speed_buff += 30
			$PoisonTimer.start()
		
func shoot():
	if shoot_cooldown == 0 and main_item != []:
		if main_item[0] == 6:
			var new_seed = seed.instantiate()
			new_seed.global_position = position
			new_seed.look_at(get_global_mouse_position())
			new_seed.damage = 2
			new_seed.on_fire = on_fire
			get_parent().add_child(new_seed)
			shoot_cooldown = 0.1
			main_item[1] -= 1
		if main_item[0] == 7:
			for n in range(-2,3):
				var new_seed = seed.instantiate()
				new_seed.lifetime = 1
				new_seed.global_position = position
				new_seed.damage = 3
				new_seed.look_at(get_global_mouse_position())
				new_seed.rotation += ((PI/12) * n)
				new_seed.on_fire = on_fire
				get_parent().add_child(new_seed)
			shoot_cooldown = 1
			main_item[1] -= 1
		if main_item[1] <= 0:
			main_item = []
			
func PoisonTimer() -> void:
	heal(-1)
	$PoisonTimer.start()
	
func burn(lenght = 5):
	if not on_fire:
		on_fire = true
		$Hitbox/Fire/Anim.play("burn")
		$FireTimer.start()
		$BurnTimer.start(lenght)
	
func FireTimer() -> void:
	heal(-1)
	$FireTimer.start()

func Extinguish() -> void:
	$FireTimer.stop()
	$Hitbox/Fire/Anim.play("RESET")
	on_fire = false
	if keep_burning:
		burn(5)

func heal(amount:float):
	health += amount
	$RyanHealthBar.value = health
