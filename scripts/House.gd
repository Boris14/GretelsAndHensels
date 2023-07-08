extends StaticBody2D

signal health_changed(new_health, max_health)

@export var max_health = 100 

var _bodies_behind = []
var _curr_health = max_health

func eat(eat_speed):
	if _curr_health > 0:
		_curr_health -= eat_speed
		health_changed.emit(_curr_health, max_health)
		if _curr_health <= 0:
			pass
			# lose the game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body_behind in _bodies_behind:
		if $BehindArea.get_overlapping_bodies().find(body_behind) == -1:
			body_behind.z_index = 2
			_bodies_behind.erase(body_behind)
			
	for body in $BehindArea.get_overlapping_bodies():
		if _bodies_behind.find(body) == -1:
			_bodies_behind.append(body)
		body.z_index = 0
