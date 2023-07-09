extends TextureRect

signal button_released(selected_food)
var sweet_scene = preload("res://scenes/Sweet.tscn")
var _selected_food = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn_sweeet(sweet_type):
	print("spawn sweet")
	var sweet = sweet_scene.instantiate()
	sweet.position = $Center.get_global_position()
	
	sweet.sweet_type = sweet_type
	get_node("../../Sweets").add_child(sweet)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Popsicle.modulate.a = 0.7
	$Waffle.modulate.a = 0.7
	$Chocolate.modulate.a = 0.7
	
	var food_preference = Globals.FOOD_TYPE.CHOCOLATE
	if Rect2($Popsicle.position, $Popsicle.size).has_point(get_local_mouse_position()):
		_selected_food = Globals.FOOD_TYPE.POPSICLE
		$Popsicle.modulate.a = 1
	elif Rect2($Waffle.position, $Waffle.size).has_point(get_local_mouse_position()):
		_selected_food = Globals.FOOD_TYPE.WAFFLE
		$Waffle.modulate.a = 1
	elif Rect2($Chocolate.position, $Chocolate.size).has_point(get_local_mouse_position()):
		_selected_food = Globals.FOOD_TYPE.CHOCOLATE
		$Chocolate.modulate.a = 1
	else:
		_selected_food = null
		
	if Input.is_action_just_released("mouse_right"):
		print(_selected_food)
		spawn_sweeet(_selected_food)
		button_released.emit(_selected_food)
		queue_free()
