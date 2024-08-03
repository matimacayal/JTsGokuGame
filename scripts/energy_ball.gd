extends Area2D

const SPEED = 120
const RANGE = 300
var direction = Vector2.RIGHT
@onready var sprite = $Sprite2D

var travelled_distance = 0

func _ready():
	print("energy ball ready")
	if direction == Vector2.LEFT:
		sprite.flip_h = true
		sprite.position = Vector2(-6,-2)

func _physics_process(delta):
	
	position += direction * SPEED * delta

	travelled_distance += SPEED * delta
	#print("moving energy ball, travelled distance: " + str(travelled_distance))
	if travelled_distance > RANGE:
		queue_free()

func set_direction(flip_h):
	if !flip_h:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT

func _on_body_entered(body):
	queue_free()
	
	if body.has_method("die"):
		body.die()
