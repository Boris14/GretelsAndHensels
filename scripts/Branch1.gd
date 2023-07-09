extends Sprite2D

var rot_offset = 0.
var time = 0.
var speed = randf_range(0.75, 1.25)
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	rot_offset= rotation_degrees + randf_range(-35.,35.)
	speed = randf_range(0.75, 1.25)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * speed
	rotation_degrees = rot_offset + 20. * sin(time)
	pass
