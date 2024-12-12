extends Area2D

func _on_body_entered(body):
	if body is PlayerInstanceReal and body != get_parent():
		get_parent().is_attacking = true
		body.die()
		
