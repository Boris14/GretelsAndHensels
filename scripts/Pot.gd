extends Area2D

signal kid_cooked
signal kid_eaten(kid_food_pref)

@export var cooking_time = 5.0

enum POT_STATE {EMPTY, COOKING, READY}
@export var state = POT_STATE.EMPTY

var _kid = null

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("pots")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func start_cooking(kid):
	if not state == POT_STATE.EMPTY:
		return false
	state = POT_STATE.COOKING
	_kid = kid
	_kid.diabled = true
	await get_tree().create_timer(cooking_time).timeout
	state = POT_STATE.READY
	kid_cooked.emit()
	return true
	
func eat_kid():
	if not state == POT_STATE.READY:
		return false
	kid_eaten.emit(_kid.food_preference)
	_kid.queue_free()
	_kid = null
	state = POT_STATE.EMPTY
	return true
	
	
