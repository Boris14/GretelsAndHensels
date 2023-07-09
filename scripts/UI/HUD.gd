extends Control

const SweetSelector = preload("res://scripts/UI/SweetSelector.gd")
const BabaYaga = preload("res://scripts/BabaYaga.gd")

@onready var sweet_selector_scene = preload("res://scenes/UI/SweetSelector.tscn")
@onready var healthbar_scene = preload("res://scenes/UI/Healthbar.tscn")
@onready var baba_yaga = get_node("../BabaYaga") as BabaYaga
@onready var _healthbar = get_node("Healthbar")

var sweet_selector = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var _house = get_node("../House")
	get_node("../../Level").connect("day_passed", _healthbar._on_day_passed)
	_house.connect("health_changed", _healthbar._on_house_health_changed)
	baba_yaga.connect("magic_changed", _healthbar._on_magic_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
func _on_player_ability_pressed():
	if sweet_selector:
		return
	sweet_selector = sweet_selector_scene.instantiate() as SweetSelector
	sweet_selector.position = get_local_mouse_position()
	sweet_selector.position = sweet_selector.position - sweet_selector.size / 2
	sweet_selector.connect("button_released", baba_yaga._on_sweet_selector_button_released)
	sweet_selector.connect("button_released", _on_sweet_selector_button_released)
	add_child(sweet_selector)
	
func _on_sweet_selector_button_released(selected_food, pos):
	sweet_selector = null
