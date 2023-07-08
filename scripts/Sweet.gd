extends Node2D

@export var sweet_type = Globals.FOOD_TYPE.CHOCOLATE
@export var life = 100

@export var chocolate_texture = preload("res://images/food/chocolate.png")
@export var popsicle_texture = preload("res://images/food/popsicle.png") 
@export var waffle_texture = preload("res://images/food/waffle.png") 

func eat(eat_speed):
	if life > 0:
		life -= eat_speed
		if life <= 0:
			$AnimationPlayer.play("despawn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Sweet ready", sweet_type)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Image/Sprite2D.texture = chocolate_texture if sweet_type == Globals.FOOD_TYPE.CHOCOLATE else popsicle_texture if sweet_type == Globals.FOOD_TYPE.POPSICLE else waffle_texture
