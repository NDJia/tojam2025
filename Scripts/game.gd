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

var choco_var = 5
## Amount of Water tiles

var choco_size = 5
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
		
	for x in range(1,choco_size + 1):
		var new_choco = load("res://Scenes/Islands/Choco/Choco"+ str(randi_range(1,choco_var)) +".tscn").instantiate()
		new_choco.position = Vector2(water_size*tile_size*16 + fire_size*tile_size*16 + x*tile_size*16,0)
		add_child(new_choco)
		
	var hell_island = load("res://Scenes/Islands/ToHell.tscn").instantiate()
	hell_island.position = Vector2(water_size*tile_size*16 + fire_size*tile_size*16 + choco_size*tile_size*16 + 24*16,0)
	add_child(hell_island)
