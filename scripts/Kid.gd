extends CharacterBody2D

signal escaped

const boy_body_scene = preload("res://scenes/BoyBody.tscn")
const girl_body_scene = preload("res://scenes/GrilBody.tscn")
var sex = Globals.SEX.BOY
@export var food_preference = Globals.FOOD_TYPE.CHOCOLATE

@export var speed = 10
@export var eat_speed = 10

enum KID_STATE {RUNNING, EATING, CAUGHT}
@export var state = KID_STATE.RUNNING
var sight_radius = 500
var eat_radius = 10
var carry_node = null

@onready var escape_timer = Timer.new()

func _ready():
	sex  =  Globals.SEX.BOY if randi_range(0,1) == 0 else Globals.SEX.GIRL
	$Body/Scale/Body/Head.texture  = load("res://images/kid/" + ("girl" if sex == Globals.SEX.GIRL else "boy") + "/head.png")
	$Body/Scale/Body/Head/Eyes.texture  = load("res://images/kid/" + ("girl" if sex == Globals.SEX.GIRL else "boy") + "/eyes.png")
	$Body/Scale/Body/Head/Eyes/Irises.texture  = load("res://images/kid/" + ("girl" if sex == Globals.SEX.GIRL else "boy") + "/irises.png")
	$Body/Scale/Body/L_Arm.texture  = load("res://images/kid/" + ("girl" if sex == Globals.SEX.GIRL else "boy") + "/l_arm.png")
	# repeat above for r_hand, l_leg, r_leg, body
	$Body/Scale/Body/R_Arm.texture  = load("res://images/kid/" + ("girl" if sex == Globals.SEX.GIRL else "boy") + "/r_arm.png")
	$Body/Scale/Body/L_Leg.texture  = load("res://images/kid/" + ("girl" if sex == Globals.SEX.GIRL else "boy") + "/l_leg.png")
	$Body/Scale/Body/R_Leg.texture  = load("res://images/kid/" + ("girl" if sex == Globals.SEX.GIRL else "boy") + "/r_leg.png")
	$Body/Scale/Body/Body.texture  = load("res://images/kid/" + ("girl" if sex == Globals.SEX.GIRL else "boy") + "/body.png")

	$sfx_chew.connect("finished", _on_chew_sound_finished)
	
	#$Area2D/CollisionShape2D.shape.radius = eat_radius
	escape_timer.connect("timeout", _escape_timer_handle)
	escape_timer.set_one_shot(true)
	add_child(escape_timer)
	#$Area2D/CollisionShape2D.shape.radius = eat_radius
	add_to_group("kids")
	var food_preference_r = randi_range(0,2)
	food_preference =  Globals.FOOD_TYPE.CHOCOLATE if food_preference_r == 0 else Globals.FOOD_TYPE.POPSICLE if food_preference_r == 1 else Globals.FOOD_TYPE.WAFFLE
	$Body/Scale/Body/food.texture = load("res://images/food/chocolate.png" if food_preference == Globals.FOOD_TYPE.CHOCOLATE else "res://images/food/popsicle.png" if food_preference == Globals.FOOD_TYPE.POPSICLE else "res://images/food/waffle.png")
	var speed_r = randf_range(0.5, 1.5)
	speed = 70 * speed_r

func _escape_timer_handle():
	if carry_node:
		escaped.emit()
		$sfx_bite.play()
	escape_timer.stop()

func try_to_escape(_witch_strength):
	escape_timer.set_wait_time(_witch_strength * 1.0)
	escape_timer.start()

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
	escape_timer.stop()

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
		$sfx_chew.stop()
		return
	elif state == KID_STATE.EATING and not $sfx_chew.playing:
		$sfx_chew.play()
	elif not $sfx_chew.playing:
		$sfx_chew.stop()
	
	$Body/vfx_popsicle_1.emitting = state == KID_STATE.EATING && food_preference == Globals.FOOD_TYPE.POPSICLE
	$Body/vfx_popsicle_2.emitting = state == KID_STATE.EATING && food_preference == Globals.FOOD_TYPE.POPSICLE
	$Body/vfx_chocolate_1.emitting = state == KID_STATE.EATING && food_preference == Globals.FOOD_TYPE.CHOCOLATE
	$Body/vfx_chocolate_2.emitting = state == KID_STATE.EATING && food_preference == Globals.FOOD_TYPE.CHOCOLATE
	$Body/vfx_waffle_1.emitting = state == KID_STATE.EATING && food_preference == Globals.FOOD_TYPE.WAFFLE
	$Body/vfx_waffle_2.emitting = state == KID_STATE.EATING && food_preference == Globals.FOOD_TYPE.WAFFLE
	get_sweet_for_eating( walk_towards_sweet, eat_sweet(delta), walk_towards_house)
	$Body.set_scale(Vector2(-sign(velocity.x),1))

func _on_chew_sound_finished():
	if state == KID_STATE.EATING:
		$sfx_chew.play()
