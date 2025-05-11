extends CanvasLayer

# Preload food images
const coffee = preload("res://Assets/Textures/Foods/Coffee.png")
const pepper = preload("res://Assets/Textures/Foods/PepperRed.png")
const pretzel = preload("res://Assets/Textures/Foods/Pretzel.png")
const orange = preload("res://Assets/Textures/Foods/Orange.png")
const brownie = preload("res://Assets/Textures/Foods/Brownie.png")
const watermelon = preload("res://Assets/Textures/Foods/Watermelon.png")
const apple = preload("res://Assets/Textures/Foods/Apple.png")
const pumpkin = preload("res://Assets/Textures/Foods/Pumpkin.png")

const food_list = [null, coffee, pepper, pretzel, orange, brownie, watermelon, apple, pumpkin]

var player
@onready var health = $Health
var items
var range_skill

@onready var passives = [$PowerBar/Passive1, $PowerBar/Passive2, $PowerBar/Passive3, $PowerBar/Passive4]
@onready var passives_images = [$PowerBar/Passive1/texture, $PowerBar/Passive2/texture, $PowerBar/Passive3/texture, $PowerBar/Passive4/texture]
@onready var passives_timers = [$PowerBar/Passive1/timer, $PowerBar/Passive2/timer, $PowerBar/Passive3/timer, $PowerBar/Passive4/timer]
@onready var special_img = $RangedPower/texture
@onready var special_ammo = $RangedPower/timer

func _ready():
	player = get_node("../Player")
	items = player.active_items
	range_skill = player.main_item

func _process(_dt):
	health.text = str(int(player.health))
	# iterate through the active item list
	for i in range(4):
		var item = items[i + 1]
		var img = passives_images[i]
		var timer = passives_timers[i]
		if item != []:
			img.texture = food_list[item[0]]
			timer.text = str(int(item[1]))
	
	print(range_skill)
	if range_skill != []:
		special_img.texture = food_list[range_skill[0]]
		special_ammo.text = str(int(range_skill[1]))
