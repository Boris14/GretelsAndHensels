extends Node2D

const HUD = preload("res://scripts/UI/HUD.gd")
const SweetSelector = preload("res://scripts/UI/SweetSelector.gd")
const BabaYaga = preload("res://scripts/BabaYaga.gd")

var _bodies = []

@onready var hud = $HUD as HUD
@onready var baba_yaga = $BabaYaga as BabaYaga
#@onready var sweet_selector = $HUD/Sweet as SweetSelector

func _sort_bodies_by_y_pos():
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
	_sort_bodies_by_y_pos()
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit() 