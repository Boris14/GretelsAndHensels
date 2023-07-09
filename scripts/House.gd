extends StaticBody2D

signal health_changed(new_health, max_health)

@export var max_health = 100 

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
	pass

