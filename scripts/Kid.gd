extends CharacterBody2D

signal escaped

const boy_body_scene = preload("res://scenes/BoyBody.tscn")
const girl_body_scene = preload("res://scenes/GrilBody.tscn")

@export var food_preference = Globals.FOOD_TYPE.CHOCOLATE

@export var speed = 10
@export var eat_speed = 10

enum KID_STATE {RUNNING, EATING, CAUGHT}
@export var state = KID_STATE.RUNNING
var sight_radius = 500
var eat_radius = 10
var carry_node = null
var escape_after_caught = 1.

func _ready():
	#$Area2D/CollisionShape2D.shape.radius = eat_radius
	var _body_scene = boy_body_scene if randi() % 2 else girl_body_scene
	#var _body = _body_scene.instantiate()
	#_body.set_name("Body")
	#$Body/Scale.add_child(_body)
	add_to_group("kids")
	var food_preference_r = randi_range(0,2)
	food_preference =  Globals.FOOD_TYPE.CHOCOLATE if food_preference_r == 0 else Globals.FOOD_TYPE.POPSICLE if food_preference_r == 1 else Globals.FOOD_TYPE.WAFFLE
	var speed_r = randf_range(0.5, 1.5)
	speed = 100 * speed_r

func try_to_escape(_witch_strength):
	await get_tree().create_timer(_witch_strength * 1.0).timeout
	if carry_node:
		escaped.emit()

func get_house_location():
	var house = get_node("../../House")
	return house.get_global_position()

func get_sweet_for_eating(k_walk, k_edible, k_failure):
	var _house = get_node("../../House")
	var sweets_node = get_node("../../Sweets")
	var sweets_unfiltered = sweets_node.get_children()
	# find the closest sweet that is closer than sight_radius and has sweet_type == food_preference and if there is such a sweet call k_success with it as an argument and if there isnt call k_failure()
	var sweets_filtered = sweets_unfiltered.filter(func (x): return x.get_global_position().distance_to(get_global_position()) < sight_radius and x.sweet_type == food_preference)
	if sweets_filtered.size() > 0:
		sweets_filtered.sort_custom(func (a,b): return a.position.distance_to(position) < b.position.distance_to(position))
		var sweets = sweets_filtered
		if sweets[0].get_global_position().distance_to(get_global_position()) < eat_radius:
			k_edible.call(sweets[0])
		else:
			k_walk.call(sweets[0])
	else:	
		for body in $Area2D.get_overlapping_bodies():
			if(body == _house):
				k_edible.call(_house)
				return
		k_failure.call()

func grab(carrier, strength):
	rotate(PI/2)
	carry_node = carrier
	state = KID_STATE.CAUGHT
	$Anim.play("idle")
	try_to_escape(strength)

func drop():
	rotate(-PI/2)
	carry_node = null
	state = KID_STATE.RUNNING

func move(vel):
	velocity = vel
	move_and_slide()
	
func walk_towards_sweet(sweet):
	state = KID_STATE.RUNNING
	move(position.direction_to(sweet.position) * speed)
	$Anim.play("walk")

func eat_sweet(delta): 
	return func(sweet):
		state = KID_STATE.EATING;
		sweet.eat(eat_speed * delta)
		$Anim.play("eat_house")

func walk_towards_house():
	state = KID_STATE.RUNNING
	move(position.direction_to(get_house_location()) * speed)
	$Anim.play("walk")

func _physics_process(delta):
	if state == KID_STATE.CAUGHT:
		position = carry_node.global_position + Vector2(0, 50)
		return
		
	get_sweet_for_eating( walk_towards_sweet, eat_sweet(delta), walk_towards_house)
	$Body.set_scale(Vector2(-sign(velocity.x),1))
