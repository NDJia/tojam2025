extends CanvasLayer

func _ready():
	$Resume.pressed.connect(resume)
	$ToMainMenu.pressed.connect(to_menu)
	
func resume():
	get_tree().paused = false
	hide()

func to_menu():
	get_tree().change_scene_to_file("res://Scenes/UI/mainmenu.tscn")
