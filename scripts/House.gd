extends StaticBody2D

signal health_changed(new_health, max_health)

@export var max_health = 100 

@onready var flicker_timer = Timer.new()
@onready var eating_timer = Timer.new()

const MODULATE_COLOR = Color8(255, 255, 255)
var _is_dark = false
var _is_eaten = false

var _curr_health = max_health

func eat(eat_speed):
	_is_eaten = true
	if flicker_timer.is_stopped():
		flicker_timer.start()
	if _curr_health > 0:
		_curr_health -= eat_speed
		health_changed.emit(_curr_health, max_health)
		if _curr_health <= 0:
			pass # lose the game
	eating_timer.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	flicker_timer.set_one_shot(false)
	flicker_timer.set_wait_time(0.2)
	flicker_timer.connect("timeout", _flicker_timer_handle)
	add_child(flicker_timer)
	eating_timer.set_one_shot(true)
	eating_timer.set_wait_time(0.1)
	eating_timer.connect("timeout", _eating_timer_handle)
	add_child(eating_timer)

func _flicker_timer_handle():
	_is_dark = not _is_dark
	if _is_dark:
		$Sprite2D.modulate = MODULATE_COLOR.darkened(0.1)
	else:
		$Sprite2D.modulate = MODULATE_COLOR

func _eating_timer_handle():
	_is_eaten = false
	flicker_timer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HouseShadew.z_index = 0

