extends CharacterBody2D

@export var speed : int = 200
@export var id : int = 0

var vel = Vector2()

func get_input():
	vel = Vector2()
	if Input.is_action_pressed("right"):
		vel.x += 1
	if Input.is_action_pressed('left'):
		vel.x -= 1
	if Input.is_action_pressed('down'):
		vel.y += 1
	if Input.is_action_pressed('up'):
		vel.y -= 1
	vel = vel.normalized() * speed

func _physics_process(delta):
	get_input()
	set_velocity(vel)
	move_and_slide()
