extends Node2D

const HUD = preload("res://scripts/UI/HUD.gd")
const SweetSelector = preload("res://scripts/UI/SweetSelector.gd")
const BabaYaga = preload("res://scripts/BabaYaga.gd")

const NIGHT_COLOR = Color8(12, 19, 67)

var _bodies = []
var _curr_lighting = 1.0

@export var day_duration = 8.0

@onready var hud = $HUD as HUD
@onready var baba_yaga = $BabaYaga as BabaYaga
#@onready var sweet_selector = $HUD/Sweet as SweetSelector

var _is_day = true

func _sort_bodies_by_y_pos():
	for _body in _bodies:
		if not _body:
			_bodies.erase(_body)
	
	for i in range(0, _bodies.size() - 1):
		for j in range(i, _bodies.size()):
			if _bodies[i].get_global_position().y > _bodies[j].get_global_position().y:
				var _to_swap = _bodies[i]
				_bodies[i] = _bodies[j]
				_bodies[j] = _to_swap
	var _z_index = 0
	for _body in _bodies:
		_body.z_index = _z_index
		_z_index += 1

# Called when the node enters the scene tree for the first time.
func _ready():
	_bodies.append($House)
	_bodies.append($BabaYaga)
	_bodies.append($Pot)
	for kid in $Kids.get_children():
		_bodies.append(kid)
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var _step = delta * (-0.05 if _is_day else 0.05)
	_curr_lighting += _step
	if _is_day and _curr_lighting <= 0.4:
		_is_day = false
	elif not _is_day and _curr_lighting >= 1:
		_is_day = true
	print(_curr_lighting)
	modulate = NIGHT_COLOR.lightened(_curr_lighting)
	
	_sort_bodies_by_y_pos()
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit() 
