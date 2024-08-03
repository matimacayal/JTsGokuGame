extends Node2D

const SPEED = 60

var direction = 1

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
var dying = false

func _ready():
	animation.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dying:
		return
	
	if ray_cast_right.is_colliding():
		direction = -1
		sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		sprite.flip_h = false
	
	position.x += direction * SPEED * delta

func die():
	dying = true
	animation.play("death")
