extends Node2D

var tile_size = 24
## How many tiles do each tile consists of (24x24)

var water_var = 5
## Amount of Water tiles

var water_size = 5
## Amount of Water tile to generate

var fire_var = 5
## Amount of Water tiles

var fire_size = 5
## Amount of Water tile to generate

func _ready() -> void:
	var new_island = load("res://Scenes/Islands/IslandCenter.tscn").instantiate()
	new_island.position = Vector2(0,0)
	add_child(new_island)
	
	for x in range(1,water_size + 1):
		var new_water = load("res://Scenes/Islands/Water/Water"+ str(randi_range(1,water_var)) +".tscn").instantiate()
		new_water.position = Vector2(x*tile_size*16,0)
		add_child(new_water)
	
	for x in range(1,fire_size + 1):
		var new_fire = load("res://Scenes/Islands/Fire/Fire"+ str(randi_range(1,fire_var)) +".tscn").instantiate()
		new_fire.position = Vector2(water_size*tile_size*16 + x*tile_size*16,0)
		add_child(new_fire)
	
	
	'''
	for y in range(-map_size,map_size+1):
		for x in range(-map_size,map_size+1):
			if x == 0 and y == 0:
				var new_island = load("res://Scenes/Islands/IslandCenter.tscn").instantiate()
				new_island.position = Vector2(x * (tile_size*16), y * (tile_size*16))
				add_child(new_island)
			else:
				var new_island = load("res://Scenes/Islands/Island"+ str(randi_range(1,var_num)) +".tscn").instantiate()
				new_island.position = Vector2(x * (tile_size*16), y * (tile_size*16))
				add_child(new_island)
	'''
