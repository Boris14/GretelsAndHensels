extends Node2D

@export var max_kids_count = 5

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
	var kid_pos = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
	while kid_pos.x == 0 or kid_pos.y == 0:
		kid_pos = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
	kid.position = kid_pos * randf_range(1000,1920)
	add_child(kid)
