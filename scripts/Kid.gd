extends CharacterBody2D



@export var food_preference = Globals.FOOD_TYPE.CHOCOLATE

@export var speed = 10
@export var eat_speed = 10.

enum KID_STATE {RUNNING, EATING, CAUGHT}
@export var state = KID_STATE.RUNNING
var sight_radius = 100
var eat_radius = 10
var witch_node = null
var caught_timer = 0.
var escape_after_caught = 1.
func _ready():
	
	var food_preference_r = randi_range(0,2)
	food_preference =  Globals.FOOD_TYPE.CHOCOLATE if food_preference_r == 0 else Globals.FOOD_TYPE.POPSICLE if food_preference_r == 1 else Globals.FOOD_TYPE.WAFFLE
	var speed_r = randf_range(0.5,1.5)
	speed = 10 * speed_r
	var eat_speed_r = randf_range(0.5,1.5)
	eat_speed = 10 * eat_speed_r

func get_house_location():
	var house = get_node("../House")
	return house.get_global_position()

func get_sweet_for_eating(k_walk, k_edible, k_failure):
	var sweets_node = get_node("../Sweets")
	var sweets_unfiltered = sweets_node.get_children()
	# find the closest sweet that is closer than sight_radius and has sweet_type == food_preference and if there is such a sweet call k_success with it as an argument and if there isnt call k_failure()
	var sweets_filtered = sweets_unfiltered.filter(func (x): return x.get_global_position().distance_to(get_global_position()) < sight_radius and x.sweet_type == food_preference)
	if sweets_filtered.length > 0:
		var sweets = sweets_filtered.sorted(func (x): x.get_global_position().distance_to(get_global_position()))
		if sweets[0].get_global_position().distance_to(get_global_position()) < eat_radius:
			k_edible.call(sweets[0])
		else:
			k_walk.call(sweets[0])
	else:
		k_failure.call()

func grab(witch):
	witch_node = witch
	caught_timer = 0.
	escape_after_caught = randf_range(0.5,1.5)
	state = KID_STATE.CAUGHT

func drop():
	witch_node = null
	caught_timer = 0.
	escape_after_caught = 0.
	state = KID_STATE.RUNNING

func move(vel):
	velocity = vel
	move_and_slide()

func _physics_process(delta):
	get_sweet_for_eating(
		(func (sweet): move(position.direction_to(sweet.position) * speed)), 
		(func(sweet): sweet.eat(eat_speed * delta); state = KID_STATE.EATING),
		(func(): move(position.direction_to(get_house_location()) * speed)))
	pass
