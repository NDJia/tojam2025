extends CanvasLayer

var player
@onready var health = $Health

func _ready():
	player = get_node("../Player")

func _process(_dt):
	health.text = str(int(player.health))
