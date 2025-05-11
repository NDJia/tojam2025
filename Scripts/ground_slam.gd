extends Node2D
var time = 0.5
## How long the damage stays active

func _ready() -> void:
	$SmashAnim.play("BOOM")

func _process(delta: float) -> void:
	time -= delta
	if time < 0:
		time = 0
	if $Hitbox.has_overlapping_areas() and time != 0:
		for enemy in $Hitbox.get_overlapping_areas():
			enemy.get_parent().hit(10)
			enemy.get_parent().push(10,global_position)



func _on_smash_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "BOOM":
		queue_free()
