extends CharacterBody2D

@export var speed: float = 120.0
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Tracks last movement vector for idle animations
var last_input: Vector2 = Vector2.DOWN

func _physics_process(delta):
	var input_vector := Vector2.ZERO

	# Custom Input Map
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
		move_and_slide()

		last_input = input_vector
		update_walk_animation(last_input)
	else:
		velocity = Vector2.ZERO
		update_idle_animation(last_input)


# Walking animation based on input vector
func update_walk_animation(dir: Vector2):
	if dir.y > 0:
		if dir.x < 0:
			anim_sprite.animation = "walk front left"
		elif dir.x > 0:
			anim_sprite.animation = "walk front right"
		else:
			anim_sprite.animation = "walk front"

	elif dir.y < 0:
		if dir.x < 0:
			anim_sprite.animation = "walk back left"
		elif dir.x > 0:
			anim_sprite.animation = "walk back right"
		else:
			anim_sprite.animation = "walk back"

	else:
		# Horizontal-only movement
		if dir.x < 0:
			anim_sprite.animation = "walk front left"
		elif dir.x > 0:
			anim_sprite.animation = "walk front right"

	anim_sprite.play()


# Idle animation based on last input
func update_idle_animation(dir: Vector2):
	if dir.y > 0:
		if dir.x < 0:
			anim_sprite.animation = "idle front left"
		elif dir.x > 0:
			anim_sprite.animation = "idle front right"
		else:
			anim_sprite.animation = "idle front"

	elif dir.y < 0:
		if dir.x < 0:
			anim_sprite.animation = "idle back left"
		elif dir.x > 0:
			anim_sprite.animation = "idle back right"
		else:
			anim_sprite.animation = "idle back"

	else:
		# Horizontal-only idle defaults to front
		if dir.x < 0:
			anim_sprite.animation = "idle front left"
		elif dir.x > 0:
			anim_sprite.animation = "idle front right"
		else:
			anim_sprite.animation = "idle front"

	anim_sprite.play()
