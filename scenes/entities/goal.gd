extends Area2D

# Which player this goal belongs to (1 = left, 2 = right)
@export var player_number = 1

func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Check if the ball entered
	if body.is_in_group("ball"):
		# Determine which player scored
		var scoring_player = 2 if player_number == 1 else 1
		
		# Ball will handle the scoring through its signal
		body._on_screen_exited()
