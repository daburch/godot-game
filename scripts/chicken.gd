extends CharacterBody2D

@export var speed = 40

var chasing = false
var target = null

var in_attack_range = false
var ready_to_attack = true

@export var health = 50
@export var attack_power = 10
@export var defence = 0

func enemy():
	pass

func _physics_process(delta):
	var animation = $animated_sprite
	
	if chasing and target != null:
		var target_direction = target.position - position
		animation.flip_h = (target_direction.x > 0)
		velocity = target_direction * speed * delta
		animation.play('walking')
	else:
		velocity = Vector2(0, 0)
		animation.play("dip")
		
	move_and_slide()
	send_attack()

func _on_detection_range_body_entered(body):
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
	ready_to_attack = true

func send_attack():
	if ready_to_attack and in_attack_range and target != null and target.has_method("player"):
		ready_to_attack = false
		$attack_cooldown.start()
		target.recieve_attack(attack_power)

func recieve_attack(power):
	var damage = power - ( defence / 10.0 )
	health -= damage
	if health <= 0:
		self.queue_free()
