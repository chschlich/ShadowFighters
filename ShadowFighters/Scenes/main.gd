extends Node2D

@onready var player1 = $CharacterBody2D
@onready var player2 = $CharacterBody2D2
# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label2.set_text(str(3 - player1.bcounter))
	$Label3.set_text(str(3 - player2.bcounter))
