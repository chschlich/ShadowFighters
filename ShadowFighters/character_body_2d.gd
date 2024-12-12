class_name PlayerInstanceReal extends CharacterBody2D

const SPEED = 275
const JUMP_VELOCITY = -400.0
var counter: int
var dcounter: int
@export var left: String = "left"
@export var right: String = "right"
@export var attack: String = "attack"
@export var directionblock: int = 1
var frozen: bool = false
@export var is_attacking: bool = false
@export var bcounter: int
@onready var deathtimer = $death_timer

signal died

func _ready():
	$AnimationPlayer.play("idle")
	get_node("Area2D/attack_collision").set_deferred("disabled", true)
	get_node("FollowUp/follow_up_attack").set_deferred("disabled", true)
	dcounter = 0

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis(left, right)
	if !frozen:
		if direction:
			velocity.x = direction * SPEED
			if velocity.x > 0:
				$AnimationPlayer.play("walk")
			elif velocity.x < 0:
				$AnimationPlayer.play("balk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$AnimationPlayer.play("idle")
		
	if Input.is_action_just_pressed(attack):
		frozen = true
		if $followup_timer.is_stopped() and is_attacking == false:
			get_node("Area2D/attack_collision").set_deferred("disabled", false)
			$AnimationPlayer.play("crouchkick")
			$cancel_window.start()
			$ck_timer.start()
		if $cancel_window.time_left != 0 and is_attacking == true:
			$ck_timer.stop()
			$ck_timer.set_wait_time(.535)
			$kill_timer.start()
			$AnimationPlayer.play("kill")
			get_node("FollowUp/follow_up_attack").set_deferred("disabled", false)
			get_node("Area2D/attack_collision").set_deferred("disabled", true)
			counter = 0
		$followup_timer.start()
			
	if !frozen:
		move_and_slide()

func die():
	var direction := Input.get_axis(left, right)
	if direction ==  -directionblock and $hit_timer.is_stopped() and bcounter <= 3:
		bcounter += 1
		$block_timer.start()
		$AnimationPlayer.play("block")
		if $block_timer.time_left != 0:
			frozen = true
			velocity.x = 0
	else:
		dcounter += 1
		if $hit_timer.is_stopped and dcounter == 1:
			$GPUParticles2D.emitting = true
			$hit_timer.start()
			frozen = true
			$AnimationPlayer.play("hit")
		if dcounter == 2:
			$GPUParticles2D2.emitting = true
			$hit_timer.stop()
			$hit_timer.set_wait_time(.775)
			frozen = true 
			deathtimer.start()
			$AnimationPlayer.play("death")

func _on_ck_timer_timeout():
	get_node("Area2D/attack_collision").set_deferred("disabled", true)
	frozen = false
	is_attacking = false


func _on_hit_timer_timeout():
	frozen = false
	dcounter = 0


func _on_followup_timer_timeout():
	frozen = false

func _on_block_timer_timeout():
	frozen = false


func _on_kill_timer_timeout():
	get_node("FollowUp/follow_up_attack").set_deferred("disabled", true)
	frozen = false
	is_attacking = false


func _on_death_timer_timeout():
	dcounter = 0
	emit_signal("died")
	get_tree().quit(3)
