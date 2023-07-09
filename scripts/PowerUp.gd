extends TextureRect

@export var strength_texture = preload("res://images/UI/IMG_4431.png")
@export var speed_texture = preload("res://images/UI/IMG_4432.png")
@export var magic_texture = preload("res://images/UI/IMG_4430.png")

@export var lifetime = 2.0
@export var ascent_speed = 100.0

func init(type, in_position):
	position = in_position
	match type:
		Globals.FOOD_TYPE.CHOCOLATE:
			texture = strength_texture
		Globals.FOOD_TYPE.WAFFLE:
			texture = speed_texture
		Globals.FOOD_TYPE.POPSICLE:	
			texture = magic_texture
			
# Called when the node enters the scene tree for the first time.
func _ready():
	z_as_relative = false
	z_index = 20


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifetime -= delta
	position.y -= delta * ascent_speed
	if lifetime <= 0:
		queue_free()
