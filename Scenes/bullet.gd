extends Area2D


var tilemap
var speed = 80

var direction : Vector2

var damage

func _ready():
	tilemap = get_tree().root.get_node("main/TileMap")


## find the position of the bullet at each frame

func _process(delta):
	position = position + speed*direction*delta

func _on_body_entered(body):
	#Ignore collision with player
	if body.name == "Player":
		return
	if body.name == "TileMap":
		if tilemap.get_layer_name(2):
			return
	
	if body.name == "enemy":
		pass
		##TODO Add functionality for animation and setup health and stamina variables for enemy
