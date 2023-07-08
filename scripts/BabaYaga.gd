extends CharacterBody2D


const SPEED = 300.0

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = get_viewport().get_mouse_position() - position
	if direction.length() > SPEED:
		velocity = direction.normalized() * SPEED
	else:
		velocity = direction

	move_and_slide()
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit() 
