extends KinematicBody2D

var ACCELERATION = 10000
var MAX_SPEED = 50
var FRICTION = 1000
var velocity = Vector2.ZERO
var is_running = null
onready var Timer = get_node("Timer")
const walk_speed = 95
const run_speed = 150
const run_acceleration = 10000
const walk_acceleration = 10000
const longrun_speed = 1650
const run_friction = 10000
const walk_friction = 1000
var total_time_pressed
onready var animation_player = $"Kris Animations"
onready var animation_tree = $"Kris Animation Organiser"
onready var animation_state = animation_tree.get("parameters/playback")

#func _unhandled_input_event() -> void:
	#Timer.wait_time = 2.5
	#Timer.start(is_button_pressed("X"))

func _process(delta: float) -> void:
	long_press(delta)
	pass

func long_press(delta):
	if Input.is_action_pressed("ui_all"):
		total_time_pressed =+ delta
	if total_time_pressed == 2.5:
		MAX_SPEED = longrun_speed
	else:
		MAX_SPEED = run_speed



func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if is_running == true:
		
		MAX_SPEED = run_speed
		ACCELERATION = run_acceleration
		FRICTION = run_friction
	else:
		MAX_SPEED = walk_speed
		ACCELERATION = walk_acceleration
		FRICTION = walk_friction
		
	if walk_speed < 0:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_state.travel("Idle")
	
	if Input.is_action_just_pressed("X"):
		is_running = true
	if Input.is_action_just_released("X"):
		is_running = false
	
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Walk/blend_position", input_vector)
		animation_state.travel("Walk")
		animation_tree.set("parameters/Walk/blend_position", input_vector)
		animation_state.travel("Walk")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animation_state.travel("Idle")
	
	velocity = move_and_slide(velocity)
	
	#print(MAX_SPEED)




func _on_Timer_timeout():
	MAX_SPEED = longrun_speed
