extends CharacterBody2D

signal ability_pressed(can_activate)

const REACH_DIST = 8.0

@export
var normal_speed = 300.0
@export
var speed_carry_mult = 0.8
@export
var magic_regen = 2.0
@export
var strength = 5.0

var _speed = normal_speed
var _max_magic = 100.0
var _curr_magic = 0.0
var _is_carrying_kid = false

func _physics_process(delta):
	
	_speed = normal_speed * (speed_carry_mult if _is_carrying_kid else 1)
	_curr_magic = clamp(_curr_magic + magic_regen, 0, _max_magic)
	
	# Movement
	var direction = get_viewport().get_mouse_position() - position
	if direction.length() > REACH_DIST:
		velocity = direction.normalized() * _speed
	else:
		velocity = direction
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# Try to pick up a kid
		for body in $PickUpArea.get_overlapping_bodies():
			if body.is_in_group("kids"):
				body.grab(self)
				_is_carrying_kid = true
				break
		pass
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		# Open ability UI
		ability_pressed.emit(_curr_magic >= _max_magic)

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit() 

	$Anim.play("walk" if velocity.length() > 0 else "idle")	
	$Body.set_scale(Vector2(-1 if velocity.x > 0 else 1, 1))
	move_and_slide()
