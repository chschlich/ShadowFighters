extends Node2D

@onready var player1 = $CharacterBody2D
@onready var player2 = $CharacterBody2D2
@onready var gameover = $restart_screen
# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	$restart_screen.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label2.set_text(str(3 - player1.bcounter))
	$Label3.set_text(str(3 - player2.bcounter))

func on_character_body_2d_died():
	$restart_screen.show()

func on_character_body_2dp2_died():
	$restart_screen.show()
