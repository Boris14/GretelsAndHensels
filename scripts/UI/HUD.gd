extends Control

const SweetSelector = preload("res://scripts/UI/SweetSelector.gd")

@onready var sweet_selector_scene = preload("res://scenes/UI/SweetSelector.tscn")

var sweet_selector = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and not sweet_selector:
		sweet_selector = sweet_selector_scene.instantiate() as SweetSelector
		sweet_selector.position = get_local_mouse_position()
		sweet_selector.position = sweet_selector.position - sweet_selector.size / 2
		add_child(sweet_selector)
