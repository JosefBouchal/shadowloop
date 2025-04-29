extends Node2D

@export var room_scene: PackedScene
@export var enemy_scene: PackedScene
@export var enemies_per_room := 5
@export var obstacle_scene: PackedScene
@export var obstacle_count := 5

var current_room: Node2D

func _ready():
	generate_room()

func find_free_position(existing_positions, room_size, margin, min_distance):
	var max_attempts = 50  # abychom se necyklili donekonečna
	for attempt in range(max_attempts):
		var x = randf_range(margin, room_size.x - margin)
		var y = randf_range(margin, room_size.y - margin)
		var candidate = Vector2(x, y)

		var too_close = false
		for pos in existing_positions:
			if pos.distance_to(candidate) < min_distance:
				too_close = true
				break

		if not too_close:
			return candidate

	# Pokud se nepodaří najít místo po 50 pokusech, vrátíme jakékoliv
	return Vector2(randf_range(margin, room_size.x - margin), randf_range(margin, room_size.y - margin))

func generate_room():
	if current_room:
		current_room.queue_free()

	current_room = room_scene.instantiate()
	add_child(current_room)
	current_room.position = Vector2(0, 0)

	var room_size = Vector2(800, 600)  # uprav dle velikosti místnosti
	var margin = 64  # vzdálenost od okrajů
	var min_distance = 64  # minimální vzdálenost mezi objekty

	var spawn_positions = []  # seznam všech obsazených pozic

	# 🔹 Spawn nepřátel
	for i in range(enemies_per_room):
		var enemy = enemy_scene.instantiate()
		current_room.add_child(enemy)

		var position = find_free_position(spawn_positions, room_size, margin, min_distance)
		spawn_positions.append(position)

		enemy.global_position = current_room.to_global(position)

	# 🔸 Spawn překážek
	for i in range(obstacle_count):
		var obstacle = obstacle_scene.instantiate()
		current_room.add_child(obstacle)

		var position = find_free_position(spawn_positions, room_size, margin, min_distance)
		spawn_positions.append(position)

		obstacle.global_position = current_room.to_global(position)
