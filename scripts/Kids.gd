extends Node2D

@export var max_kids_count = 6

var kid_scene = preload("res://scenes/Kid.tscn")
var timer_speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if get_child_count() > max_kids_count:
		return
	$Node2D/Timer.wait_time = randf_range(timer_speed * 2., timer_speed * 3.5)
	timer_speed = max(0,timer_speed - 0.001)
	var kid = kid_scene.instantiate()
	# kid position should be a vector starting from the center of the screen 1920x1080 in a random direction, with a random length that is at least 1000 and at most 1920
	var center = Vector2(1920/2, 1080/2)
	var dir= Vector2(randf_range(-1,1), randf_range(0.1,1)).normalized()
	var kid_position = center + dir * randf_range(1000,2000)
	kid.position = kid_position

	add_child(kid)
