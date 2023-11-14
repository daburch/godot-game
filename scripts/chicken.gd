extends CharacterBody2D

var chasing = false
var target = null

var in_attack_range = false
var ready_to_attack = true

@export var max_health = 50
@export var health = 50
@export var attack_power = 10
@export var defence = 0
@export var movement_speed = 60

var egg_scene

func _ready():
	egg_scene = preload("res://scenes/egg.tscn")

func enemy():
	pass

func _physics_process(delta):
	var animation = $animated_sprite
	
	if chasing and target != null:
		var target_direction = target.global_position - global_position
		animation.flip_h = (target_direction.x > 0)
		
		velocity = velocity.move_toward(target_direction.normalized() * movement_speed, movement_speed)
		animation.play('walking')
	else:
		velocity = Vector2(0, 0)
		animation.play("dip")
		
	move_and_collide(velocity * delta)
	send_attack()

func _on_detection_range_body_entered(body):
	if body.has_method("player"):
		chasing = true
		target = body
	
func _on_detection_range_body_exited(body):
	if body == target:
		chasing = false
		target = null

func _on_hitbox_body_entered(body):
	if body == target:
		in_attack_range = true

func _on_hitbox_body_exited(body):
	if body == target:
		in_attack_range = false

func _on_attack_cooldown_timeout():
	$attack_cooldown.stop()
	ready_to_attack = true

func send_attack():
	if ready_to_attack and in_attack_range and target != null and target.has_method("player"):
		ready_to_attack = false
		$attack_cooldown.start()
		target.recieve_attack(attack_power)

func recieve_attack(power):
	var damage = power - ( defence / 10.0 )
	decrease_health(damage)
	if health <= 0:
		get_parent().find_child("respawn_timer").start()
		spawn_loot()
		self.queue_free()
		
func spawn_loot():
	var egg = egg_scene.instantiate()
	egg.position = position
	add_sibling(egg)

func increase_health(in_health: int):
	health += in_health
	if health > max_health:
		health = max_health

func decrease_health(in_health: int):
	health -= in_health
	if health < 0:
		health = 0
