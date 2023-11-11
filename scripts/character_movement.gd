extends CharacterBody2D

@export var speed = 4000
@export var current_direction = "none"
@export var has_movement_input = "none"

func get_input(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed * delta
	if input_direction.x > 0:
		current_direction = "right"
		has_movement_input=true
	elif input_direction.y > 0:
		current_direction = "down"
		has_movement_input=true
	elif input_direction.x < 0:
		current_direction = "left"
		has_movement_input=true
	elif input_direction.y < 0:
		current_direction = "up"
		has_movement_input=true
	else:
		has_movement_input=false

func play_animation():
	var animation = $AnimatedSprite2D

	if current_direction == "right":
		animation.flip_h = false
		if has_movement_input:
			animation.play("walking_side")
		else:
			animation.play("idle_side")
	elif current_direction == "left":
		animation.flip_h = true
		if has_movement_input:
			animation.play("walking_side")
		else:
			animation.play("idle_side")
	elif current_direction == "up":
		animation.flip_h = false
		if has_movement_input:
			animation.play("walking_back")
		else:
			animation.play("idle_back")
	else:
		animation.flip_h = false
		if has_movement_input:
			animation.play("walking_front")
		else:
			animation.play("idle_front")

func _physics_process(delta):
	get_input(delta)
	play_animation()
	move_and_slide()
