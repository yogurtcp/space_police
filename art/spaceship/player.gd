extends Area2D

@export var acceleration_radial = 600
@export var top_speed_radial = 400
var speed_radial = 0

@export var acceleration_tangential = 600
@export var top_speed_tangential = 300
var speed_tangential = 0

@export var acceleration_rotation = deg_to_rad(720)
@export var top_speed_rotation = deg_to_rad(180)
var speed_rotation = 0



var angle = 0
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):#	

	var autocorrect = true
	
	# roataion
	var rotating = Input.is_action_pressed("rotate_right") or Input.is_action_pressed("rotate_left")
	var drifting = Input.is_action_pressed("drift_right") or Input.is_action_pressed("drift_left")
	
	if Input.is_action_pressed("rotate_right") or (autocorrect and not rotating and speed_rotation < 0):
		speed_rotation += acceleration_rotation * delta
	elif Input.is_action_pressed("rotate_left") or (autocorrect and not rotating and speed_rotation > 0):
		speed_rotation -= acceleration_rotation * delta
	
	speed_rotation = clamp(speed_rotation, -top_speed_rotation, top_speed_rotation) 
	rotation += speed_rotation* delta
	
	# acceleration
	if Input.is_action_pressed("accelerate"):
		speed_radial += acceleration_radial * delta
	elif Input.is_action_pressed("decelerate"):
		speed_radial -= acceleration_radial * delta
	
	if Input.is_action_pressed("drift_right") or (autocorrect and not drifting and speed_tangential < 0):
		speed_tangential += acceleration_tangential * delta
	elif Input.is_action_pressed("drift_left") or (autocorrect and not drifting and speed_tangential > 0):
		speed_tangential -= acceleration_tangential * delta
	
	speed_radial = clamp(speed_radial, -0.2*top_speed_radial, top_speed_radial)
	speed_tangential = clamp(speed_tangential, -top_speed_tangential, top_speed_tangential)
	
	var velocity = Vector2(speed_radial*cos(rotation)-speed_tangential*sin(rotation), 
							speed_radial*sin(rotation)+speed_tangential*cos(rotation))
								
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
#	print("speed_radial: " + str(speed_radial))
#	print("velocity: " + str(velocity))
#	print("position: " + str(position))

	$AnimatedSprite2D.play()

