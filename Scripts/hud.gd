extends CanvasLayer

var player

func _ready():
	player = get_node("../Player")

func _process(_dt):
	$Health.text = str(int(player.health))
