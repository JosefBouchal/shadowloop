extends CharacterBody2D

@export var speed := 40
@export var health := 20
@onready var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player:
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * speed
		move_and_slide()

func take_damage(amount):
	health -= amount
	print("Sliz dostal zásah! Zbývá životů: ", health)
	if health <= 0:
		print("Sliz byl poražen!")
		queue_free()
