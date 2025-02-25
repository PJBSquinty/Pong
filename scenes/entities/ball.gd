extends CharacterBody2D

# Ball speed
@export var initial_speed = 300.0
@export var speed_increase = 20.0
@export var max_speed = 1000.0

var current_speed = initial_speed
var screen_size
var direction = Vector2.ZERO

signal goal_scored(player)

func _ready():
	screen_size = get_viewport_rect().size
	reset_ball()

func _physics_process(delta):
	# Calculate frame-rate independent movement
	var normalized_delta = delta * 60.0
	
	# Move the ball - velocity already contains speed
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		# Handle collision
		var collider = collision.get_collider()
		
		# Playing a bounce sound
		$BounceSound.play()
		
		# Bounce the ball
		velocity = velocity.bounce(collision.get_normal())
		
		# Increase speed if hitting paddle
		if collider is CharacterBody2D:  # Paddle is CharacterBody2D
			current_speed += speed_increase * normalized_delta
			current_speed = min(current_speed, max_speed)
			
			# Apply current speed to velocity direction
			velocity = velocity.normalized() * current_speed

func reset_ball():
	# Reset position to center
	position = screen_size / 2
	
	# Reset speed
	current_speed = initial_speed
	
	# Random direction (within 45 degrees of horizontal)
	var random_angle = randf_range(-PI/4, PI/4)
	if randf() > 0.5:  # 50% chance to go left or right
		random_angle += PI  # Add 180 degrees to go left
	
	direction = Vector2(cos(random_angle), sin(random_angle))
	velocity = direction * current_speed

func _on_screen_exited():
	# Play score sound
	$ScoreSound.play()
	
	# Determine which player scored based on ball position
	if position.x < 0:
		emit_signal("goal_scored", 2)  # Player 2 scored
	elif position.x > screen_size.x:
		emit_signal("goal_scored", 1)  # Player 1 scored
	
	# Reset the ball after short delay
	await get_tree().create_timer(1.0).timeout

	reset_ball()
