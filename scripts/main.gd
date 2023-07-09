extends Node2D

const HUD = preload("res://scripts/UI/HUD.gd")
const SweetSelector = preload("res://scripts/UI/SweetSelector.gd")
const BabaYaga = preload("res://scripts/BabaYaga.gd")

const NIGHT_COLOR = Color8(12, 19, 67)

var _bodies = []
var _curr_lighting = 1.0
var _changing_day = false

@export var day_duration = 4.0

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
	$Pot.connect("kid_eaten", baba_yaga._on_kid_eaten)
	
	_bodies.append($House)
	_bodies.append($BabaYaga)
	_bodies.append($Pot)
	randomize()
	change_day()

func change_day():
	_changing_day = true
	await get_tree().create_timer(day_duration).timeout
	_changing_day = false
	_is_day = not _is_day

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not _changing_day:
		var _step = delta * (-0.1 if _is_day else 0.1)
		_curr_lighting += _step
		if (_is_day and _curr_lighting <= 0.5) or (not _is_day and _curr_lighting >= 1):
			change_day()
	modulate = NIGHT_COLOR.lightened(_curr_lighting)
	
	for kid in $Kids.get_children():
		if _bodies.find(kid) == -1:
			_bodies.append(kid)
	_sort_bodies_by_y_pos()
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit() 
