extends Node

# Game State Variables
var player1_score = 0
var player2_score = 0
@export var winning_score = 10

# Game states
enum GameState {READY, PLAYING, GAME_OVER}
var current_state = GameState.READY

func _ready():
	# Connect signals from goals and ball
	$Ball.connect("goal_scored", Callable(self, "_on_goal_scored"))
	
	# Set initial state
	change_state(GameState.READY)
	
	# Setup input actions if they don't exist
	_setup_input_actions()

func _process(_delta):
	# Delta time is used in child nodes but not needed for state management
	# as these are just conditional checks
	
	# Handle game state
	match current_state:
		GameState.READY:
			if Input.is_action_just_pressed("start_game"):
				change_state(GameState.PLAYING)
		
		GameState.GAME_OVER:
			if Input.is_action_just_pressed("restart_game"):
				# Reset scores and start a new game
				player1_score = 0
				player2_score = 0
				update_score_display()
				change_state(GameState.READY)

# Manage Game State
func change_state(new_state):
	current_state = new_state
	
	match new_state:
		GameState.READY:
			$HUD/GameStatus.text = "Press Space to Start"
			$Ball.hide()
		
		GameState.PLAYING:
			$HUD/GameStatus.text = ""
			$Ball.show()
			$Ball.reset_ball()
		
		GameState.GAME_OVER:
			var winner = "Player 1" if player1_score >= winning_score else "Player 2"
			$HUD/GameStatus.text = winner + " Wins!\nPress R to Restart"
			$Ball.hide()

# Update score
func _on_goal_scored(player):
	# Increment score
	if player == 1:
		player1_score += 1
	else:
		player2_score += 1
	
	# Update HUD
	update_score_display()
	
	# Check for game over
	if player1_score >= winning_score or player2_score >= winning_score:
		change_state(GameState.GAME_OVER)
	else:
		# Continue playing
		$Ball.reset_ball()

func update_score_display():
	$HUD/LeftScore.text = str(player1_score)
	$HUD/RightScore.text = str(player2_score)

# Check if actions exist, if not create them
func _setup_input_actions():
	if not InputMap.has_action("p1_up"):
		InputMap.add_action("p1_up")
		var ev = InputEventKey.new()
		ev.keycode = KEY_W
		InputMap.action_add_event("p1_up", ev)
	
	if not InputMap.has_action("p1_down"):
		InputMap.add_action("p1_down")
		var ev = InputEventKey.new()
		ev.keycode = KEY_S
		InputMap.action_add_event("p1_down", ev)
	
	if not InputMap.has_action("p2_up"):
		InputMap.add_action("p2_up")
		var ev = InputEventKey.new()
		ev.keycode = KEY_UP
		InputMap.action_add_event("p2_up", ev)
	
	if not InputMap.has_action("p2_down"):
		InputMap.add_action("p2_down")
		var ev = InputEventKey.new()
		ev.keycode = KEY_DOWN
		InputMap.action_add_event("p2_down", ev)
	
	if not InputMap.has_action("start_game"):
		InputMap.add_action("start_game")
		var ev = InputEventKey.new()
		ev.keycode = KEY_SPACE
		InputMap.action_add_event("start_game", ev)
	
	if not InputMap.has_action("restart_game"):
		InputMap.add_action("restart_game")
		var ev = InputEventKey.new()
		ev.keycode = KEY_R
		InputMap.action_add_event("restart_game", ev)
