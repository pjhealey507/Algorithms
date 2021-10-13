extends KinematicBody2D

#For collision identification
var type = "Enemy"

#Movement Variables
var velocity = Vector2()
var movespeed = 150
var knockbackspeed = 400
var speed = movespeed

var health = 2

var follow
var playerposition

func _ready():
	pass
	
func _physics_process(delta):
	playerposition = $"/root/ShieldGame/Player".global_position
	handle_movement()

#Follow logic
func handle_movement():
	if follow == true:
		velocity = playerposition - position
	move_and_slide(velocity.normalized() * speed)

#Collision logic
func _on_ShieldHitRange_body_entered(body):
	#Do nothing if colliding with a wall
	if body.is_in_group("Wall"):
		return
	
	#Knockback if colliding with bashing shield
	if body.type == "Shield" and body.bashing == true:
		var shieldposition = body.global_position
		knockback(shieldposition)
		
	#Knockback if colliding with thrown shield
	if body.type == "ThrownShield":
		var shieldposition = body.global_position
		knockback(shieldposition)

func _on_KnockbackTimer_timeout():
	velocity = Vector2(0,0)
	follow = true
	speed = movespeed

#Follow player if they enter a certain range
func _on_AcquisitionRange_body_entered(body):
	if body.is_in_group("Wall"):
		return
	if body.type == "Player":
		follow = true

#Knockback logic
func knockback(shieldposition):
	velocity = -((shieldposition - position)/21.75)
	speed = knockbackspeed
	follow = false
	$ShieldHitRange/KnockbackTimer.start()
