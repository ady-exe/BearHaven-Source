extends CharacterBody2D

#region === CONSTANTS ===

const SPEED: float = 120.0

#region === ANIMATION CONSTANTS ===

# --- Animation States ---
const STATE_WALK: String = "walk"
const STATE_IDLE: String = "idle"


# --- Vertical Animation States ---
# Vertical Animation for Direction
const DIR_FRONT: String = "front"
const DIR_BACK: String = "back"


# --- Horizontal Animation States ---
# Horizontal Direction for Animations
const DIR_LEFT: String = " left"
const DIR_RIGHT: String = " right"

#endregion

#endregion


#region === NODE REFERENCES ===

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

#endregion


#region === STATE ===

var last_input: Vector2 = Vector2.DOWN

#endregion


#region === MAIN LOOP ===

func _physics_process(_delta: float) -> void:
	var input_vector := _get_input_vector()

	if input_vector != Vector2.ZERO:
		_handle_movement(input_vector)
		_update_animation(STATE_WALK, input_vector)
	else:
		_stop_movement()
		_update_animation(STATE_IDLE, last_input)

#endregion


#region === INPUT ===

func _get_input_vector() -> Vector2:
	var input_vector := Vector2.ZERO

	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	return input_vector.normalized() if input_vector != Vector2.ZERO else Vector2.ZERO

#endregion


#region === MOVEMENT ===

func _handle_movement(direction: Vector2) -> void:
	velocity = direction * SPEED
	move_and_slide()
	last_input = direction


func _stop_movement() -> void:
	velocity = Vector2.ZERO

#endregion


#region === ANIMATION ===

func _update_animation(state: String, dir: Vector2) -> void:
	var anim_name := _build_animation_name(state, dir)

	if anim_sprite.animation != anim_name:
		anim_sprite.animation = anim_name
		anim_sprite.play()


func _build_animation_name(state: String, dir: Vector2) -> String:
	var vertical := DIR_FRONT
	var horizontal := ""

	# Vertical priority
	if dir.y > 0:
		vertical = DIR_FRONT
	elif dir.y < 0:
		vertical = DIR_BACK

	# Horizontal modifier
	if dir.x < 0:
		horizontal = DIR_LEFT
	elif dir.x > 0:
		horizontal = DIR_RIGHT

	return state + " " + vertical + horizontal

#endregion
