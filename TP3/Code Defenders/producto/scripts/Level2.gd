extends "res://scripts/Level.gd"

export var song: AudioStream

var boss1 = preload("res://Boss1.tscn")

func _ready():
	randomize()
	start_level()

func start_level():
	set_player()
	set_boss()
	setNivel(2)
	setEnemigos()
	$AnimationPlayer.play("main 2")
	set_music(song)

func set_boss():
	$Boss2.start()

func _on_Boss2_broken_shield():
	$BossHealthBar.start()

func _on_BossHealthBar_dead():
	$Boss2.stop()
