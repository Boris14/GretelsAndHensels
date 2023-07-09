extends Node2D

@export var sweet_type = Globals.FOOD_TYPE.CHOCOLATE
@export var life = 100

@export var chocolate_texture = preload("res://images/food/chocolate.png")
@export var popsicle_texture = preload("res://images/food/popsicle.png") 
@export var waffle_texture = preload("res://images/food/waffle.png") 

@onready var flicker_timer = Timer.new()
@onready var eating_timer = Timer.new()

const MODULATE_COLOR = Color8(255, 255, 255)
var _is_dark = false
var _is_eaten = false

func _eating_timer_handle():
	_is_eaten = false
	flicker_timer.stop()
	$Image.modulate = MODULATE_COLOR

func eat(eat_speed):
	_is_eaten = true
	if flicker_timer.is_stopped():
		flicker_timer.start()
	if life > 0:
		life -= eat_speed
		if life <= 0:
			$AnimationPlayer.play("despawn")
	eating_timer.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	flicker_timer.set_one_shot(false)
	flicker_timer.set_wait_time(0.15)
	flicker_timer.connect("timeout", _flicker_timer_handle)
	add_child(flicker_timer)
	eating_timer.set_one_shot(true)
	eating_timer.set_wait_time(0.1)
	eating_timer.connect("timeout", _eating_timer_handle)
	add_child(eating_timer)

func _flicker_timer_handle():
	_is_dark = not _is_dark
	if _is_dark:
		$Image.modulate = MODULATE_COLOR.darkened(0.5)
	else:
		$Image.modulate = MODULATE_COLOR

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Image/Sprite2D.texture = chocolate_texture if sweet_type == Globals.FOOD_TYPE.CHOCOLATE else popsicle_texture if sweet_type == Globals.FOOD_TYPE.POPSICLE else waffle_texture
