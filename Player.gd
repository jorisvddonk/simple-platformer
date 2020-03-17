extends KinematicBody2D


const ACCELERATION = 512
const GRAVITY = 220
const MAX_SPEED = 52
const AIR_RESISTANCE = 0.1
const FRICTION = 0.3
const JUMP_FORCE = 130

var motion = Vector2(0,0)

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		animationPlayer.play("Run")
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input <= 0
	else:
		animationPlayer.play("Stand")
		
	motion.y += GRAVITY * delta
	
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)

		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		animationPlayer.play("Jump")
		if Input.is_action_just_released("ui_up"):
			if motion.y < -JUMP_FORCE/2:
				motion.y = -JUMP_FORCE/2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE)
	
	motion = move_and_slide(motion, Vector2.UP)
