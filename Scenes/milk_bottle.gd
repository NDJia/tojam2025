extends Node2D
var target: Vector2
var broken = false

func _ready() -> void:
	$AnimationPlayer.play("Up")
	await($AnimationPlayer.animation_finished)
	$AnimationPlayer.play("spin")

func _process(delta: float) -> void:
	if not broken:
		global_position += (target - global_position).normalized() * 100 * delta
	if global_position.distance_to(target) < 100 and not broken:
		$AnimationPlayer.play("Down")
		await($AnimationPlayer.animation_finished)
		$AnimationPlayer.play("Break")
		broken = true
		await($AnimationPlayer.animation_finished)
		$AnimationPlayer.play("fade_out")
		await($AnimationPlayer.animation_finished)
		queue_free()
		
