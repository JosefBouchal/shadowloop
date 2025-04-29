extends Area2D

@export var speed := 300
var direction := Vector2.ZERO
var damage := 10

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	print("Zásah detekován: ", body)

	if "take_damage" in body:
		print("Zkouším zavolat take_damage()")
		body.take_damage(damage)
		queue_free()
	elif body is StaticBody2D:
		print("Náraz do překážky!")
		queue_free()

func _ready():
	await get_tree().create_timer(1.5).timeout
	queue_free()
