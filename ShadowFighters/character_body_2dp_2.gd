class_name PlayerInstanceReal2 extends CharacterBody2D


const SPEED = 200
const JUMP_VELOCITY = -400.0
@export var counter: int
var dcounter: int

@onready var hit_timer = $hit_timer

func _ready():
	$AnimatedSprite2D.play("idle")
	get_node("Area2D/attack_collision").set_deferred("disabled", true)
	get_node("FollowUp/follow_up_attack").set_deferred("disabled", true)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x < 0:
			$AnimatedSprite2D.play("walk")
		elif velocity.x > 0:
			$AnimatedSprite2D.play("balk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("attack2") and $attack_lag.time_left == 0:
		counter += 1
		if $ck_timer.time_left == 0 and counter == 1 and $followup_timer.time_left == 0:
			get_node("Area2D/attack_collision").set_deferred("disabled", false)
			$AnimatedSprite2D.play("crouchkick")
			$ck_timer.start()
			$cancel_window.start()
			$followup_timer.start()
		if counter == 2 and $cancel_window.time_left != 0:
			$followup_timer.stop()
			$followup_timer.set_wait_time(.9)
			$followup_timer.start()
			$AnimatedSprite2D.play("kill")
			get_node("FollowUp/follow_up_attack").set_deferred("disabled", false)
			get_node("Area2D/attack_collision").set_deferred("disabled", true)
			counter = 0
			$attack_lag.start()
		if $followup_timer.time_left == 0:
			counter = 0
			

	move_and_slide()

func die():
	if Input.is_action_pressed("right"):
		$block_timer.start()
		$AnimatedSprite2D.play("block")
		if $block_timer.time_left != 0:
			set_physics_process(false)
			velocity.x = 0
	else:
		dcounter += 1
		if hit_timer.time_left == 0 and dcounter == 1:
			hit_timer.start()
			set_physics_process(false)
			$AnimatedSprite2D.play("hit")
		if dcounter == 2:
			$AnimatedSprite2D.play("death")
			counter = 0

func _on_ck_timer_timeout():
	get_node("Area2D/attack_collision").set_deferred("disabled", true)
	set_physics_process(true)

func _on_hit_timer_timeout():
	set_physics_process(true)
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("idle")
	get_tree().quit(3)

func _on_followup_timer_timeout():
	get_node("FollowUp/follow_up_attack").set_deferred("disabled", true)

func _on_block_timer_timeout():
	set_physics_process(true)
