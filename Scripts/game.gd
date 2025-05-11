extends Node2D

@export var map_size = 2
## How many map tiles should generate (2 is half of the map)

@export var tile_size = 24
## How many tiles do each tile consists of (24x24)

@export var var_num = 3
## Amount of island variation in the game

func _ready() -> void:
	for y in range(-map_size,map_size+1):
		for x in range(-map_size,map_size+1):
			if x == 0 and y == 0:
				var new_island = load("res://Scenes/Islands/IslandCenter1.tscn").instantiate()
				new_island.position = Vector2(x * (tile_size*16), y * (tile_size*16))
				add_child(new_island)
			else:
				var new_island = load("res://Scenes/Islands/Island"+ str(randi_range(1,var_num)) +".tscn").instantiate()
				new_island.position = Vector2(x * (tile_size*16), y * (tile_size*16))
				add_child(new_island)
