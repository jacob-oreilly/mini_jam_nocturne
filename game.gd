extends Node2D

const NOTE = preload("res://notes.tscn")
@onready var note_spawn_left: Marker2D = $NoteSpawnLeft
@onready var note_spawn_right: Marker2D = $NoteSpawnRight
var rng = RandomNumberGenerator.new()
var leftHitEntered = false;
var rightHitEntered = false;
var left_note_body: RigidBody2D = null
var right_note_body: RigidBody2D = null

#func _ready() -> void:

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("hit_left"):
		if leftHitEntered:
			remove_child(left_note_body)
			print("left hit")
			leftHitEntered = false
		else:
			print("left miss")
	if Input.is_action_just_pressed("hit_right"):
		if rightHitEntered:
			remove_child(right_note_body)
			print("right hit")
			rightHitEntered = false
		else:
			print("right miss")
		

func _on_timer_timeout() -> void:
	var randomNumber = rng.randi_range(1, 2)
	var nextNote = NOTE.instantiate()
	if randomNumber == 1:
		nextNote.global_position = note_spawn_left.global_position
	elif randomNumber == 2:
		nextNote.global_position = note_spawn_right.global_position
	add_child(nextNote)
	print("Timer finished!")
	#get_tree().change_scene_to_file("res://game_end.tscn")
	


func _on_left_hit_body_entered(body: Node2D) -> void:
	left_note_body = body
	leftHitEntered = true;

func _on_right_hit_body_entered(body: Node2D) -> void:
	right_note_body = body
	rightHitEntered = true;


func _on_left_hit_body_exited(body: Node2D) -> void:
	leftHitEntered = false;

func _on_right_hit_body_exited(body: Node2D) -> void:
	rightHitEntered = false;
