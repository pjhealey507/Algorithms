extends KinematicBody2D

#For collision identification
var type = "Enemy"

#Movement Variables
var velocity = Vector2()
var movespeed = 50
var knockbackspeed = 150
var speed = movespeed

var health = 4

var playerposition
var follow = false

var FireballScene = preload("res://Fireball.tscn")

func _ready():
	pass

func _physics_process(delta):
	playerposition = $"/root/ShieldGame/Player".global_position
	handle_movement()

#
func handle_movement():
	if follow == true:
		velocity = playerposition - position
	move_and_slide(velocity.normalized() * speed)

#Instances Fireball scene
func shoot():
	var Fireball = FireballScene.instance()
	get_parent().add_child(Fireball)
	Fireball.position = position

#When player enters range, start attacking and following
func _on_AcquisitionRange_body_entered(body):
	if body.is_in_group("Wall"):
		return
	if body.type == "Player":
		$MageSprite.play("Attacking")
		$ShootTimer.start()
		follow = true

#Timer controls rate of fire
func _on_ShootTimer_timeout():
	shoot()

#Handles knockback
func knockback(shieldposition):
	velocity = -((shieldposition - position)/21.75)
	speed = knockbackspeed
	follow = false
	$ShieldHitRange/KnockbackTimer.start()

#Continue following after knockback
func _on_KnockbackTimer_timeout():
	velocity = Vector2(0,0)
	follow = true
	speed = movespeed

#Knocback when hit by shield
func _on_ShieldHitRange_body_entered(body):
	if body.is_in_group("Wall"):
		return
	if body.type == "Shield" and body.bashing == true:
		var shieldposition = body.global_position
		knockback(shieldposition)
	if body.type == "ThrownShield":
		var shieldposition = body.global_position
		knockback(shieldposition)
