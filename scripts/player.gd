extends CharacterBody2D

@export var health = 100
@export var speed = 4000
@export var current_direction = "down"
@export var has_movement_input = false

var defence = 10

enum {
	IDLE,
	WALK,
	ATTACK
}
var state = WALK 

func player():
	pass

func get_input(delta):
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		velocity = Vector2(0, 0)
		return

	if state == ATTACK:
		return

	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed * delta
	if input_direction.x > 0:
		current_direction = "right"
		state = WALK
	elif input_direction.y > 0:
		current_direction = "down"
		state = WALK
	elif input_direction.x < 0:
		current_direction = "left"
		state = WALK
	elif input_direction.y < 0:
		current_direction = "up"
		state = WALK
	else:
		state = IDLE

func play_directional_animation(animation, side, back, front):
	if current_direction == "right":
		animation.flip_h = false
		animation.play(side)
	elif current_direction == "left":
		animation.flip_h = true
		animation.play(side)
	elif current_direction == "up":
		animation.flip_h = false
		animation.play(back)
	else:
		animation.flip_h = false
		animation.play(front)

func play_animation():
	match state:
		IDLE:
			play_directional_animation($animated_sprite, "idle_side", "idle_back", "idle_front")
		WALK:
			play_directional_animation($animated_sprite, "walking_side", "walking_back", "walking_front")
		ATTACK:
			play_directional_animation($animated_sprite, "attack_side", "attack_back", "attack_front")

func recieve_attack(power):
	var damage = power - ( defence / 10.0 )
	health -= damage

func _physics_process(delta):
	get_input(delta)
	play_animation()
	move_and_slide()

func _on_animated_sprite_animation_finished():
	if state == ATTACK:
		state = IDLE
