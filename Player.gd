extends CharacterBody2D

@export var speed := 100
@export var attack_range := 300
@export var damage := 10
@export var projectile_scene: PackedScene

func _input(event):
	if event.is_action_pressed("attack"):
		attack()

func _physics_process(delta):
	var direction := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity = direction * speed
	move_and_slide()

func attack():
	if projectile_scene:
		var projectile = projectile_scene.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = global_position

		var mouse_pos = get_global_mouse_position()
		var shoot_direction = (mouse_pos - global_position).normalized()
		projectile.direction = shoot_direction
