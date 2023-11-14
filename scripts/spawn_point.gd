extends Node2D

@export var enemy = CHICKEN

var enemy_scene = null

enum {
	CHICKEN
}

func _ready():
	match enemy:
		CHICKEN:
			enemy_scene = preload("res://scenes/chicken.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_respawn_timer_timeout():
	$respawn_timer.stop()
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(0, 0)
	add_child(enemy)
