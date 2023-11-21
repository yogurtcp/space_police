extends Node
@export var rock_scene: PackedScene

func new_game():
	print("starting timer for game")
	_on_rock_timer_timeout()
	$StartTimer.start()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_hit():
	pass # Replace with function body.


func _on_rock_timer_timeout():
	# Create a new instance of the Mob scene.
	var rock = rock_scene.instantiate()

	# Choose a random location on Path2D.
	var rock_spawn_location = get_node("RockPath/RockSpawnLocation")
	rock_spawn_location.progress_ratio = randf()

	# Set the rock's direction perpendicular to the path direction.
	var direction = rock_spawn_location.rotation + PI / 2

	# Set the rock's position to a random location.
	rock.position = rock_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	rock.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	rock.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(rock)
	print("spawning")


func _on_start_timer_timeout():
	print("starting timer for rocks")
	$RockTimer.start()
