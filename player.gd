extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -500.0

var start_x := 0.0
var max_distance := 0.0
var has_won := false


func _ready() -> void:
	%Death.text = "Deaths: %d" % Global.death_count
	start_x = global_position.x
	max_distance = 0.0
	%Score.text = "Score: %d" % max_distance


func _physics_process(delta: float) -> void:
	if has_won:
		if Input.is_key_pressed(KEY_R):
			get_tree().call_deferred("reload_current_scene")
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left" , "ui_right")
	if direction:
		velocity.x = direction * SPEED
		$Sprite2D.flip_h = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	var distance := global_position.x - start_x
	if distance > max_distance:
		max_distance = distance
		%Score.text = "Score: %d" % max_distance


func _on_area_2d_body_entered(_body: Node2D) -> void:
	Global.death_count += 1
	%Death.text = "Deaths: %d" % Global.death_count
	get_tree().call_deferred("reload_current_scene")


func _on_finish_body_entered(_body: Node2D) -> void:
	has_won = true
	%Win.visible = true
	%Restart.visible = true
