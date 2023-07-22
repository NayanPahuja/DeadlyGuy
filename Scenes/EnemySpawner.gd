extends Node2D

var spawnPosition


var tilemap ## so that our enemy does not spawn on our houses/foliage

@export var spawn_area : Rect2 = Rect2(50, 150, 700, 700) 

@export var max_enemies = 20

@export var existing_enemies = 5

var enemy_count = 0

var enemy_scene = preload("res://Scenes/cactus.tscn")

var rng  = RandomNumberGenerator.new()


func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	var valid_location = false
	while !valid_location:
		enemy.position.x = spawn_area.position.x + rng.randf_range(0, spawn_area.size.x)
		enemy.position.y = spawn_area.position.y + rng.randf_range(0, spawn_area.size.y)
		
		valid_location = valid_spawn_location(enemy.position)
		enemy.spawn()
func valid_spawn_location(position : Vector2):
		# Check if the cell type in this position is grass or sand, which is a valid location.
		#In our tilemap layer, 0 = water, 1 = sand, 2 = grass, 3 = foliage, etc
		var valid_location = (tilemap.get_layer_name(1)) || (tilemap.get_layer_name(2))

		# If the two conditions are true, the position is valid
		return valid_location
