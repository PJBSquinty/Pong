extends CharacterBody2D

# Paddle movement speed
@export var speed = 400.0
# Player number (1 for left, 2 for right)
@export var player_number = 1

# Get the gravity from the project settings to be synced with RigidBody nodes
var screen_size

func _ready():
	# Get the viewport size
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	# Handle Input
	var direction = 0
	
	if player_number == 1:
		# Player 1 controls (left paddle)
		if Input.is_action_pressed("p1_up"):
			direction = -1
		elif Input.is_action_pressed("p1_down"):
			direction = 1
	else:
		# Player 2 controls (right paddle)
		if Input.is_action_pressed("p2_up"):
			direction = -1
		elif Input.is_action_pressed("p2_down"):
			direction = 1
	
	# Set the velocity - multiply by delta for frame-rate independence
	velocity.y = direction * speed * delta * 60.0
	
	# Move the paddle
	move_and_slide()
	
	# Clamp position to screen edges (with a small margin)
	var half_height = $CollisionShape2D.shape.size.y / 2
	position.y = clamp(position.y, half_height, screen_size.y - half_height)
