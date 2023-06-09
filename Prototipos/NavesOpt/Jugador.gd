extends KinematicBody2D


var screen_size # Size of the game window.
#var misil_scene = preload("res://misilJugador.tscn")
#onready var anim = $animacion
var misil_scene = preload("res://Escenas/misilJugador.tscn")
const MASS = 3
const MAX_SPEED = 500
const ACCELERATION = 1800
const DECCELERATION = 2000

var speed: float = 0
var target_angle: float = 0

var target_motion = Vector2()
var motion = Vector2()
var steering = Vector2()
var direction = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	#hide()
	

func _physics_process(delta):
	move(delta)
	if Input.is_action_just_pressed("shoot"):
		shoot()
	pass


func move(delta):
	screen_wrap()
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	if direction != Vector2():
		$turbo.show()
		$turbo.play("acelero")
		speed += ACCELERATION * delta
	else:
		$turbo.hide()
		speed -= DECCELERATION * delta
		
	speed = clamp(speed, 0, MAX_SPEED)
	
	target_motion = speed * direction.normalized() * delta
	
	steering = target_motion - motion
	
	if steering.length() > 1:
		steering = steering.normalized()
	
	motion += steering / MASS
	
		
	move_and_collide(motion)
	
	if motion != Vector2():
		target_angle = atan2(motion.x, motion.y) + PI/2
		rotation = -target_angle

#func start(pos):
#	position = pos
#	show()
#	$CollisionPolygon2D.disabled = false

func on_player_get_hit():
	#hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	#$CollisionPolygon2D.disabled = true
	
func shoot():
	var projectile = misil_scene.instance()
	projectile.start($Position2D.global_position,rotation)
	get_parent().add_child(projectile)
	
func screen_wrap():
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)	
