extends CharacterBody2D

signal ability_pressed(can_activate)

const REACH_DIST = 8.0

@export
var normal_speed = 300.0
@export
var speed_carry_mult = 0.6
@export
var magic_regen = 2.0
@export
var strength = 3.0

var _speed = normal_speed
var _max_magic = 100.0
var _curr_magic = 0.0

var _carrying_kid = null
var _is_stunned = false
var _can_grab = true

func _block_grab():
	_can_grab = false
	await get_tree().create_timer(0.5).timeout
	_can_grab = true

func grab_kid(kid):
	kid.grab($Body/Scale/Root/LArm, strength)
	kid.connect("escaped", _on_kid_escaped)
	_carrying_kid = kid
	$sfx_grab.play()
	_block_grab()

func drop_kid():
	_carrying_kid.disconnect("escaped", _on_kid_escaped)
	_carrying_kid.drop()
	_carrying_kid = null
	_block_grab()

func _on_kid_escaped():
	if not _carrying_kid:
		return
	drop_kid()
	_is_stunned = true
	await get_tree().create_timer(2.0).timeout
	_is_stunned = false

func _physics_process(delta):
	if _is_stunned:
		$Anim.play("idle")
		return
		
	_speed = normal_speed * (speed_carry_mult if _carrying_kid else 1)
	_curr_magic = clamp(_curr_magic + magic_regen, 0, _max_magic)
	
	# Movement
	var direction = get_viewport().get_mouse_position() - position
	if direction.length() > REACH_DIST:
		velocity = direction.normalized() * _speed
	else:
		velocity = direction
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and _can_grab:
		if _carrying_kid:
			for area in $PickUpArea.get_overlapping_areas():
				if area.is_in_group("pots"):
					area.start_cooking(_carrying_kid)
			drop_kid()
		else:
			var ate_kid = false
			for area in $PickUpArea.get_overlapping_areas():
				if area.is_in_group("pots"):
					ate_kid = area.eat_kid()
					break
					
			if not ate_kid:
				for body in $PickUpArea.get_overlapping_bodies():
					if body.is_in_group("kids"):
						grab_kid(body)
						break
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		ability_pressed.emit(_curr_magic >= _max_magic)

	$Anim.play("walk" if velocity.length() > REACH_DIST else "idle")	
	$Body.set_scale(Vector2(-1 if velocity.x > 0 else 1, 1))
	move_and_slide()
