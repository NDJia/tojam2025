extends CanvasLayer

@onready var creditsinfo_button = $CreditsInfo/CreditsInfoHide

func _ready():
	$Start.pressed.connect(start_game)
	$Credits.pressed.connect(show_credits)
	
	$CreditsInfo/ColorRect.size = creditsinfo_button.get_parent_area_size()
	creditsinfo_button.size = creditsinfo_button.get_parent_area_size()
	creditsinfo_button.pressed.connect(hide_credits)
	
	$Quit.pressed.connect(quit)
	

func start_game():
	get_tree().change_scene_to_file("res://Scenes/main/main.tscn")

func show_credits():
	$CreditsInfo.show()

func hide_credits():
	$CreditsInfo.hide()

func quit():
	get_tree().quit()
