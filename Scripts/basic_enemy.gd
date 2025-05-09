extends Node2D

@onready var player = get_node('../Player')
## A Refrence To The Player

var speed = 50
## Speed Of The Enemy

var condition = "Idle"
## Current Condition Of The Enemy

var range = 150
## Range Where The Enemy Detects The Player

func _physics_process(delta: float) -> void:
	position += ($Nav.get_next_path_position() - position).normalized() * delta * speed

func Update_Target() -> void:
	if position.distance_to(player.position) < range:
		condition = "Attack"
	if condition != "Idle":
		$Nav.target_position = player.position
	$UpdateTarget.start()
