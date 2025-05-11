extends CanvasLayer

func _ready():
	$Resume.pressed.connect(resume)
	$ToMainMenu.pressed.connect(to_menu())
	
func resume():
	pass

func to_menu():
	pass
