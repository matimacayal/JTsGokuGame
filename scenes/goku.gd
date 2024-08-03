extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite
@onready var hitbox = $Hitbox/CollisionShape2D
@onready var shooting_point = $ShootingPoint

var current_animation
var attacking


func _physics_process(delta):
	if attacking:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("punch") and is_on_floor():
		attacking = true
		animation.play("punch")
		current_animation = "punch"
		return
	
	if Input.is_action_just_pressed("kameha"):
		attacking = true
		animation.play("kameha")
		current_animation = "kameha"
		return

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		sprite.flip_h = false
		hitbox.position = Vector2(11,-13)
		shooting_point.position = Vector2(13,-16)
	elif direction < 0:
		sprite.flip_h = true
		hitbox.position = Vector2(-11,-13)
		shooting_point.position = Vector2(-13,-16)
	
	# Play animation
	if is_on_floor():
		if direction == 0:
			play_animation("idle")
		else:
			play_animation("walk")
	else:
		play_animation("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Function to play animation only if it's different from the current one
# Play animation only once
func play_animation(name):
	if current_animation != name:
		animation.play(name)
		current_animation = name


func _on_animation_player_animation_finished(anim_name):
	print(anim_name)
	if anim_name in ["punch", "kameha"]:
		print("attacking == false")
		attacking = false

func kameha():
	print("kameha()")
	const ENERGY_BALL = preload("res://scenes/energy_ball.tscn")
	var new_energy_ball = ENERGY_BALL.instantiate()
	new_energy_ball.global_position = $ShootingPoint.global_position
	new_energy_ball.set_direction(sprite.flip_h)
	$ShootingPoint.add_child(new_energy_ball)
