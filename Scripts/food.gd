extends Node2D
## Will randomly choose a food to spawn as. 

@export var type = 0
## If not changed, will chose a random food to spawn 

var food_amount = 8
## Number of food types

var duration = 20.0
## How long the food stays


## Basic Foods: 
# 1 Coffee - Less Jump Cooldown BUT Auto Jump
# 2 HotPepper - All Damage Causes Fire BUT You Also Burn
# 3 Pretzel - Gain Tiny Amount Of Health
# 4 Orange - Attack At End Of Jump BUT Be Slow After Jump
# 5 Brownie - You are faster BUT poisoned

## Special Foods:
# 6 Watermelon - Shoot seeds very fast BUT short distance
# 7 Apple - Shoot Seeds very slow BUT long distance
# 8 Pumpkin - Gain Health on hit BUT Takes up slot

func _ready():
	if type == 0:
		type = randi_range(1,food_amount)
	if type == 1: 
		$FoodTex.texture = load("res://Assets/Textures/Foods/Coffee.png")
		duration = 50
	elif type == 2:
		$FoodTex.texture = load("res://Assets/Textures/Foods/PepperRed.png")
		duration = 15
	elif type == 3:
		$FoodTex.texture = load("res://Assets/Textures/Foods/Pretzel.png")
		duration = 50
	elif type == 4:
		$FoodTex.texture = load("res://Assets/Textures/Foods/Orange.png")
		duration = 50
	elif type == 5:
		$FoodTex.texture = load("res://Assets/Textures/Foods/Brownie.png")
		duration = 50
	elif type == 6:
		$FoodTex.texture = load("res://Assets/Textures/Foods/Watermelon.png")
		duration = 30
	elif type == 7:
		$FoodTex.texture = load("res://Assets/Textures/Foods/Apple.png")
		duration = 10
	elif type == 8:
		$FoodTex.texture = load("res://Assets/Textures/Foods/Pumpkin.png")
		duration = 10
		
func eat():
	$Hitbox.queue_free()
	visible = false
	$Eating.play(0.1)
	await($Eating.finished)
	queue_free()
	
