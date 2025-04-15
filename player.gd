extends CharacterBody2D

@onready var anim = $AnimatedSprite2D  # Ensure you have an AnimatedSprite2D node

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
const DOUBLE_JUMP_VELOCITY = -250.0  # Slightly lower than the first jump

var jump_count = 0  # Track jumps
var was_in_air = false  # Track landing state

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Reset jump count when landing
	if is_on_floor():
		jump_count = 0
		if was_in_air:
			anim.play("jump_2")  # Play landing animation
			was_in_air = false

	# Handle jumping
	if Input.is_action_just_pressed("ui_accept"):  # Spacebar pressed
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			anim.play("jump_0")  # Play first jump animation
			jump_count = 1
			was_in_air = true
		elif jump_count == 1:  # Double jump
			velocity.y = DOUBLE_JUMP_VELOCITY
			anim.play("jump_double")  # Play double jump animation
			jump_count = 2

	# Get input direction and move the character
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			anim.play("run")  # Play run animation when on the floor
		anim.flip_h = direction < 0  # Flip sprite when moving left
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			anim.play("idle")  # Play idle animation when standing still

	# Handle animations while airborne
	if not is_on_floor():
		if velocity.y < 0 and jump_count < 2:  # Jumping up
			anim.play("jump_0")
		elif velocity.y > 0 and jump_count < 2:  # Falling down before double jump
			anim.play("jump_1")

	move_and_slide()
