extends Node2D

const HUD = preload("res://scripts/UI/HUD.gd")
const SweetSelector = preload("res://scripts/UI/SweetSelector.gd")
const BabaYaga = preload("res://scripts/BabaYaga.gd")

@onready var hud = $HUD as HUD
@onready var baba_yaga = $BabaYaga as BabaYaga
#@onready var sweet_selector = $HUD/Sweet as SweetSelector

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
