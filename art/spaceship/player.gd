extends RigidBody2D

@export var force_radial = 8000
@export var force_tangential = 6000
@export var rotation_torque = 20000
@export var base_mass = 1000
@export var max_angular_velocity = 3

func _ready():
	set_gravity_scale(0)
	mass = base_mass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):#	

	var autocorrect = true

	# roataion
	var rotating = Input.is_action_pressed("rotate_right") or Input.is_action_pressed("rotate_left")
	var drifting = Input.is_action_pressed("drift_right") or Input.is_action_pressed("drift_left")
	
	if abs(angular_velocity) < max_angular_velocity:
		if Input.is_action_pressed("rotate_right") or (autocorrect and not rotating and angular_velocity < 0):
			apply_torque_impulse(rotation_torque)
			
		elif Input.is_action_pressed("rotate_left") or (autocorrect and not rotating and angular_velocity > 0):
			apply_torque_impulse(-rotation_torque)

	var force_vector = Vector2.ZERO

	# Forward and Backward forces
	if Input.is_action_pressed("accelerate"):
		force_vector += Vector2(cos(rotation), sin(rotation)) * force_radial
	elif Input.is_action_pressed("decelerate"):
		force_vector -= Vector2(cos(rotation), sin(rotation)) * force_radial
	
	var tangent_direction = Vector2(sin(rotation), -cos(rotation))
	var tangent_velocity = tangent_direction.dot(linear_velocity)
	
	# Left and Right forces
	if Input.is_action_pressed("drift_right") or (autocorrect and not drifting and tangent_velocity > 0):
		force_vector += Vector2(cos(rotation + PI/2), sin(rotation + PI/2)) * force_tangential
	elif Input.is_action_pressed("drift_left") or (autocorrect and not drifting and tangent_velocity < 0):
		force_vector += Vector2(cos(rotation - PI/2), sin(rotation - PI/2)) * force_tangential

	# Apply the force
	if force_vector != Vector2.ZERO:
		apply_central_impulse(force_vector)
		
#	print(angular_velocity)
	# acceleration
#	if Input.is_action_pressed("accelerate"):
#		speed_radial += force_radial * delta
#	elif Input.is_action_pressed("decelerate"):
#		speed_radial -= force_radial * delta

#	if Input.is_action_pressed("drift_right") or (autocorrect and not drifting and speed_tangential < 0):
#		speed_tangential += force_tangential * delta
#	elif Input.is_action_pressed("drift_left") or (autocorrect and not drifting and speed_tangential > 0):
#		speed_tangential -= force_tangential * delta
#
#	speed_radial = clamp(speed_radial, -0.2*top_speed_radial, top_speed_radial)
#	speed_tangential = clamp(speed_tangential, -top_speed_tangential, top_speed_tangential)
#
#	var velocity = Vector2(speed_radial*cos(rotation)-speed_tangential*sin(rotation), 
#							speed_radial*sin(rotation)+speed_tangential*cos(rotation))
#
#	position += velocity * delta
#	position = position.clamp(Vector2.ZERO, screen_size)
	$AnimatedSprite2D.play()

