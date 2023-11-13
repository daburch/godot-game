extends CharacterBody2D

@export var health = 100
@export var speed = 4000
@export var current_direction = "down"
@export var has_movement_input = false

@export var defence = 10
@export var attack_power = 25

enum {
	IDLE,
	WALK,
	ATTACK
}
var state = WALK 

func _ready():
	$hitbox_pivot/sword_hitbox/CollisionShape2D.disabled = true

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

func play_directional_animation(side, right, back, front):
	if current_direction == "right":
		$AnimationPlayer.play(right)
	elif current_direction == "left":
		$AnimationPlayer.play(side)
	elif current_direction == "up":
		$AnimationPlayer.play(back)
	else:
		$AnimationPlayer.play(front)

func play_animation():
	match state:
		IDLE:
			play_directional_animation("idle_left", "idle_right", "idle_back", "idle_front")
		WALK:
			play_directional_animation("walk_left", "walk_right", "walk_back", "walk_front")
		ATTACK:
			play_directional_animation("attack_left", "attack_right", "attack_back", "attack_front")

func recieve_attack(power):
	var damage = power - ( defence / 10.0 )
	health -= damage

func _physics_process(delta):
	get_input(delta)
	play_animation()
	move_and_slide()

func _on_animation_player_animation_finished(_anim_name):
	if state == ATTACK:
		state = IDLE

func _on_sword_hitbox_area_entered(area: Area2D):
	if area.owner.has_method("enemy"):
		area.owner.recieve_attack(attack_power)
