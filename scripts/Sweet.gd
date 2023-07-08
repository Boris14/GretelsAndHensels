extends Node2D

@export var sweet_type = Globals.FOOD_TYPE.CHOCOLATE
@export var life = 100

func eat(eat_speed):
	if life > 0:
		life -= eat_speed
		if life <= 0:
			queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
