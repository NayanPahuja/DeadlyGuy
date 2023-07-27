### Enemy.gd

extends CharacterBody2D

# Enemy movement speed
@export var speed = 50
#it’s the current movement direction of the cactus enemy.
var direction : Vector2
#direction and animation to be updated throughout game state
var new_direction = Vector2(0,1) #only move one spaces
# RandomNumberGenerator to generate timer countdown value 
var rng = RandomNumberGenerator.new()
#timer reference to redirect the enemy if collision events occur & timer countdown reaches 0
var timer = 0
#player scene ref
var player
var animation

var is_attacking = false

#When the enemy enters the scene tree, we need to do two things:
#Initialize the Player node reference
#Initialize the random number generator
func _ready():
	player = get_tree().root.get_node("main/Player")
	rng.randomize()
	
# Apply movement to the enemy
func _physics_process(delta):
	var movement = speed * direction * delta
	var collision = move_and_collide(movement)

	#if the enemy collides with other objects, turn them around and re-randomize the timer countdown
	if collision != null and collision.get_collider().name != "Player":
		#direction rotation
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		#timer countdown random range
		timer = rng.randf_range(2, 5)
	#if they collide with the player 
	#trigger the timer's timeout() so that they can chase/move towards our player
	else:
		timer = 0
	if is_attacking == false:
		enemy_animations(direction)
	if $AnimatedSprite2D.animation == "spawn":
		$Timer.start()
		timer = 0
		
	is_attacking = false
func _on_timer_timeout():
	# Calculate the distance of the player's relative position to the enemy's position
	var player_distance = player.position - position
	
	#attack radius
	#turn towards player so that it can attack
	if player_distance.length() <= 20:
		sync_direction()
		direction = Vector2.ZERO
		new_direction = player_distance.normalized()
		
	#chase radius
	#chase/move towards player to attack them
	elif player_distance.length() <= 100 and timer == 0:
		direction = player_distance.normalized()
		sync_direction()
		
	#random roam radius
	elif timer == 0:
			#this will generate a random direction value
			var random_direction = rng.randf()
			#This direction is obtained by rotating Vector2.DOWN by a random angle between 0 and 2π radians (0 to 360°). 
			if random_direction < 0.05:
				#enemy stops
				direction = Vector2.ZERO
			elif random_direction < 0.1:
				#enemy moves
				direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
				sync_direction()
func enemy_animations(direction : Vector2):
		if direction != Vector2.ZERO:
		#update our direction with the new_direction
			new_direction = direction
			animation = "walk_" + return_direction(new_direction)
			$AnimatedSprite2D.play(animation)
		else:
			#play idle animation because we are still
			animation = "idle_" + return_direction(new_direction)
			$AnimatedSprite2D.play(animation)	
		
		
		#To determine the direction that the player is facing, we need to create two new variables. 
		#The first variable is the variable that we will compare against a zero vector

		
func return_direction(direction: Vector2):
	#normalize the direction for comparison so that it's length is 1
	var normalized_direction = direction.normalized()
	
	if normalized_direction.y >= .7:
		return "down"
	elif normalized_direction.y <= -.7:
		return "up"
	elif normalized_direction.x >= .7:
		#right
		$AnimatedSprite2D.flip_h = false
		return "side"
	elif normalized_direction.x <=-.7:
		#flip the animation for reusability (left)
		#left
		$AnimatedSprite2D.flip_h = true
		return "side"
		
		#Default value is empty!
	return ""
	
func sync_direction():
	if direction != Vector2.ZERO:
		new_direction = direction.normalized()	


func spawn():
	#creates an animation delay		
	$AnimatedSprite2D.play("spawn")
	is_attacking = true
	
#resets our attacking state back to false
func _on_animated_sprite_2d_animation_finished():
	pass
