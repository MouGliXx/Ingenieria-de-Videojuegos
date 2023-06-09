extends KinematicBody2D
class_name TipoNaveDisparo

const MAX_SPEED = 350
const CENTER = Vector2(450,300)
var velocidad = 1
var vidas
var golpes = 0


var random_target_pos : Vector2 = Vector2(450,300)
var disparo = preload("res://Escenas/disparoEnemigo.tscn")
onready var player = get_node("../Player")

var salirDeLaPantalla = 0;
var objetivo
var parado=0
var moviendo=0
var UltAnimacion
#var parte = preload("res://ParteNaveTres.tscn")


func _physics_process(delta):
	if (salirDeLaPantalla == 0):
		if $TiempoParado.time_left == 0:
			if moviendo == 0:
				$TiempoMovimiento.start()
				moviendo=1
				parado=0
			se_mueve(delta)
		
		if $TiempoMovimiento.time_left == 0:
			if parado == 0:
				$TiempoParado.start()
				parado=1
				moviendo=0
			espera()
	else:
		var target_position = (objetivo - position).normalized()
		look_at(objetivo)
		var collision = move_and_collide(target_position * velocidad)


func espera():
	$turbo.hide()
	look_at(player.position)
	if $esperaDisparo.time_left==0:
		shoot()
		$esperaDisparo.start()
	
	
func se_mueve(delta):
	if position.distance_to(random_target_pos) <= MAX_SPEED * delta:
		random_target_pos = CENTER + Vector2(0,300).rotated(randf() * 2 * PI)
	else:
		position += position.direction_to(random_target_pos) * MAX_SPEED * delta
		$turbo.show()
		$turbo.play("acelero")
		look_at(random_target_pos)

func shoot():
	if moviendo == 0:
		var projectile = disparo.instance()
		projectile.start($Position2D.global_position,rotation + PI)
		get_parent().add_child(projectile)
		yield($esperaDisparo, "timeout")
	

func _on_esperaDisparo_timeout():
	shoot()
	pass

	
func play(animacion):
	$nave.play(animacion)
	UltAnimacion = animacion
	
func hitted(damage):
	golpes += 1
	if golpes == vidas:
		$turbo.hide()
		play("explosion")
		$CollisionShape2D.disabled = true
		
func salirDeLaPantalla():
	salirDeLaPantalla=1
	if (position.distance_to(Vector2(1300,-75)) < position.distance_to(Vector2(1300,795))):
		objetivo = Vector2(1300,-75)
	else:
		objetivo = Vector2(1300, 795)
