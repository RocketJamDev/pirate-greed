extends Area2D

signal pickup
signal hurt

export (int) var speed
var velocity = Vector2()
var screensize = Vector2(480, 720)
var poweredup = false

func _process(delta):
	get_input()
	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	if velocity.length() > 0:
		$Sprite/anim.play("run")
		
		$Sprite.flip_h = velocity.x < 0
	else:
		$Sprite/anim.play("idle")
	pass

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
			velocity.x += 1
	if Input.is_action_pressed("ui_down"):
			velocity.y += 1
	if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		

func start(pos):
	set_process(true)
	position = pos
	$Sprite/anim.play("idle")
	
func die():
	$Sprite/anim.play("hurt")
	
	set_process(false)

func _on_Pirate_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		emit_signal("pickup", "coins")
	if area.is_in_group("powerups"):
		area.pickup()
		emit_signal("pickup", "powerup")
	if area.is_in_group("clock"):
		area.pickup()
		emit_signal("pickup", "clock")
	if area.is_in_group("obstacles"):
		emit_signal("hurt")
		die()